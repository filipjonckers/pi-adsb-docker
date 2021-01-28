FROM balenalib/rpi-raspbian:buster
ENTRYPOINT []

WORKDIR /root

RUN apt-get update -qy \
    && apt-get install --no-install-recommends -qy \
    git-core \
    git \
    wget \
    vim \
    cmake \
    libusb-1.0.0-dev \
    build-essential \
    pkg-config \
    libterm-readline-perl-perl

# not needed to run dump1090-fa but could be useful for debugging issues
RUN git clone git://git.osmocom.org/rtl-sdr.git \
    && mkdir -p ./rtl-sdr/build \
    && cd /root/rtl-sdr/build \
    && cmake ../ -DINSTALL_UDEV_RULES=ON \
    && make -j 4 \
    && make install \
    && ldconfig \
    && cp /root/rtl-sdr/rtl-sdr.rules /etc/udev/rules.d/
    
RUN wget https://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_4.0_all.deb \
    && sudo dpkg -i piaware-repository_4.0_all.deb

RUN sudo apt-get update
RUN sudo apt-get install dump1090-fa

EXPOSE 8080
EXPOSE 30001
EXPOSE 30002
EXPOSE 30003
EXPOSE 30004
EXPOSE 30005
EXPOSE 30104

WORKDIR /root/dump1090

RUN mkdir -p /run/dump1090-fa

COPY ./start.sh start.sh
RUN chmod +x start.sh

ENV DUMP_LAT="" DUMP_LON="" 

CMD ["/root/dump1090/start.sh"]
