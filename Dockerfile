FROM ubuntu:xenial
MAINTAINER nyantec

RUN apt-get -qq update; \
    apt-get -y install make sudo software-properties-common python-software-properties; \
    apt-add-repository multiverse; \
    apt-get -qq update

RUN apt-get -y install \
    wget \
    make \
    autoconf \
    automake \
    g++ \
    git \
    python3-pip \
    pkg-config \
    cppcheck \
    smitools \
    snmp-mibs-downloader \
    fonts-inconsolata \
    fonts-lato \
    fonts-lmodern \
    pandoc \
    xzdec \
    ghostscript \
    texlive \
    texlive-luatex \
    texlive-xetex \
    texlive-math-extra \
    texlive-latex-extra

ADD install_click.sh /tmp/install_click.sh
RUN /tmp/install_click.sh

ADD install_libsodium.sh /tmp/install_libsodium.sh
RUN /tmp/install_libsodium.sh
