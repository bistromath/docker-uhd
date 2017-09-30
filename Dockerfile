# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.22

ENV uhd_tag release_003_010_002_000
ENV threads 10

MAINTAINER bistromath@gmail.com version: 0.5

WORKDIR /opt

RUN apt-get update && apt-get dist-upgrade -yf && apt-get clean && apt-get autoremove && apt-get install -y git wget zip unzip \
 cmake build-essential git-core cmake g++ python-dev swig pkg-config \
 libboost-all-dev python-lxml python-sip-dev python-requests \
 libzmq3-dev python-mako python-pysnmp4 libusb-1.0-0 libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/EttusResearch/uhd.git && cd uhd && git checkout ${uhd_tag} && rm -rf .git
WORKDIR /opt/uhd/host

RUN mkdir build \
 && cd build \
 && cmake ../ -DENABLE_B100=1 -DENABLE_B200=1 -DENABLE_E100=0 -DENABLE_E300=0 -DENABLE_EXAMPLES=1 -DENABLE_DOXYGEN=0 -DENABLE_MANUAL=0 -DENABLE_MAN_PAGES=0 -DENABLE_OCTOCLOCK=0 -DENABLE_ORC=0 -DENABLE_USRP1=0 -DENABLE_USRP2=1 -DENABLE_UTILS=1 -DENABLE_X300=1 \
 && make -j${threads} \
 && make install \
 && ldconfig && cd .. && rm -rf build
