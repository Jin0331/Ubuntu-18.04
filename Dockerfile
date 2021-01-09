FROM ubuntu:18.04
MAINTAINER sempre813

ENV DEBIAN_FRONTEND=noninteractive  
RUN apt-get update -y

USER root

# Install program
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y apt-utils build-essential apt-transport-https software-properties-common && \
  apt-get install -y nano ncftp vim net-tools wget ssh htop iputils-ping sudo git make curl man unzip openssh-server openssh-client rsync wget  && \
  rm -rf /var/lib/apt/lists/*

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# install java jdk 8
RUN mkdir -p /usr/java/default
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
RUN tar -xzvf jdk-8u131-linux-x64.tar.gz -C /usr/java/default --strip-components=1
RUN rm jdk-8u131-linux-x64.tar.gz

# java env
ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
RUN rm -rf /usr/bin/java
RUN ln -s $JAVA_HOME/bin/java /usr/bin/java


# install R 3.6.3
RUN set -e \
      && ln -sf /bin/bash /bin/sh \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
      	gnupg2 gnupg1 ca-certificates software-properties-common \
      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
      && echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
                            g++ gcc gdebi-core \
                            gfortran git libapparmor1 libblas-dev libcurl4-gnutls-dev libedit2 \
                            libgtk2.0-dev libssl1.0-dev liblapack-dev libmagick++-dev \
                            libmariadb-client-lgpl-dev libglu1-mesa-dev libopenmpi-dev libpq-dev \
                            libssh2-1-dev libssl1.0-dev libxml2-dev lsb-release openmpi-bin \
                            pandoc psmisc r-base \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'install.packages(c("tidyverse", "IRkernel"))'

# install Python 3.7
# python 3.7 remove
#RUN add-apt-repository ppa:deadsnakes/ppa -y \
#    && apt-get update && apt-get install -y build-essential libpq-dev libssl-dev openssl libffi-dev zlib1g-dev \
#    && apt-get update && apt-get install -y python3-pip python3.7-dev python3.7 \
#    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

# python 3.6
RUN apt-get update \
   && apt-get install -y python3 python3-pip software-properties-common

# jupyter notebook or lab install
RUN pip3 install jupyter && jupyter notebook --generate-config  && \
    echo "c.NotebookApp.ip='*'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py
RUN pip3 install jupyterlab

# R kernel for jupyter
RUN Rscript -e 'IRkernel::installspec(user = FALSE)'

# Scala install and kernel for jupyter
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier launch --fork almond --scala 2.12.11 -- --install && \
    rm -f coursier

EXPOSE 8888

# vscode
RUN wget https://github.com/cdr/code-server/releases/download/2.1692-vsc1.39.2/code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz \
    && tar xf code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz \
    && mv code-server2.1692-vsc1.39.2-linux-x86_64 vscode \
    && rm -rf code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz
    
EXPOSE 8989

