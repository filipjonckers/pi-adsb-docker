FROM balenalib/rpi-raspbian:stretch

ENTRYPOINT []

WORKDIR /root

RUN apt-get update && apt-get install -qy apt-utils inetutils-ping perl && apt-get clean

ADD https://opensky-network.org/files/firmware/opensky-feeder_latest_armhf.deb opensky-feeder.deb

RUN dpkg -x opensky-feeder.deb /


#RUN dpkg -x opensky-feeder.deb / && \
#    rm opensky-feeder.deb && \
#    rm /usr/bin/qemu-arm-static

COPY start.sh start.sh
RUN chmod +x start.sh

CMD ["/root/start.sh"]
