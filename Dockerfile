# ESP8266 SDK Development
#
# This dockerfile builds the ESP Open SDK available at
# https://github.com/pfalcon/esp-open-sdk
#
# Build with
#    docker build -t andrmuel/esp8266-dev .

FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

# update system
RUN apt-get -qy update && apt-get -qy dist-upgrade

# install SDK prerequisites
RUN apt-get -qy --no-install-recommends install make unrar-free \
    autoconf automake libtool gcc g++ gperf flex bison texinfo gawk \
    ncurses-dev libexpat-dev python-dev python python-serial sed git \
    unzip bash help2man wget bzip2 libtool-bin ca-certificates patch

# add 'developer' user
RUN useradd -m developer

# switch to developer user
USER developer
ENV HOME /home/developer

# clone repository
RUN cd $HOME && git clone --recursive https://github.com/pfalcon/esp-open-sdk.git

# build standalone toolchain
RUN cd $HOME/esp-open-sdk && make STANDALONE=y

# update PATH
ENV PATH /home/developer/esp-open-sdk/xtensa-lx106-elf/bin:$PATH
