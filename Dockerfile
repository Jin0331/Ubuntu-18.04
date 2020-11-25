FROM ubuntu:18.04
MAINTAINER sempre813

# Setup build environment for libpam
RUN apt-get update -y


# Install program
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential apt-transport-https software-properties-common && \
  apt-get install -y nano ncftp vim net-tools wget ssh htop iputils-ping sudo git make curl man unzip  && \
  rm -rf /var/lib/apt/lists/*

# install R 3.6.3
RUN set -e \
      && ln -sf /bin/bash /bin/sh \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
      	gnupg2 gnupg1 ca-certificates software-properties-common \
      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
      && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'

#      && echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
                            apt-transport-https apt-utils curl default-jdk g++ gcc gdebi-core \
                            gfortran git libapparmor1 libblas-dev libcurl4-gnutls-dev libedit2 \
                            libgtk2.0-dev libssl1.0-dev liblapack-dev libmagick++-dev \
                            libmariadb-client-lgpl-dev libglu1-mesa-dev libopenmpi-dev libpq-dev \
                            libssh2-1-dev libssl1.0-dev libxml2-dev lsb-release openmpi-bin \
                            pandoc psmisc r-base r-cran-* sudo x11-common \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*




  
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

RUN service ssh start