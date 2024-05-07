FROM balenalib/rpi-raspbian:buster

WORKDIR /root

RUN apt-get update && apt-get install -qy iputils-ping telnet ntp wget
RUN wget https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_1.0.46-0_armhf.deb \
  && dpkg --unpack fr24feed*.deb && rm -rf fr24feed*.deb

COPY ./fr24feed.ini /etc/fr24feed.ini
COPY ./start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 8754

CMD ["/root/start.sh"]
