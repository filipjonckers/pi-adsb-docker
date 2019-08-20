FROM balenalib/rpi-raspbian:stretch

WORKDIR /root

RUN apt-get update && apt-get install -qy iputils-ping telnet ntp wget
RUN wget http://repo.feed.flightradar24.com/pool/raspberrypi-stable/f/fr24feed/fr24feed_1.0.23-8_armhf.deb
RUN dpkg --unpack fr24feed*.deb && rm -rf fr24feed*.deb

COPY ./fr24feed.ini /etc/fr24feed.ini
COPY ./start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 8754

CMD ["/root/start.sh"]

