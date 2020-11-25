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
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
	add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
	apt-get update %% apt-get install -y r-base




  
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

RUN service ssh start