FROM balenalib/rpi-raspbian:stretch

ENTRYPOINT []

RUN apt-get update && apt-get install -qy apt-utils wget
RUN wget http://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_3.6.3_all.deb \
  && dpkg -i piaware-repository_3.6.3_all.deb \
  && apt-get update \
  && apt-get install -qy piaware

COPY ./piaware.conf /etc/piaware.conf
COPY ./start.sh start.sh
RUN chmod +x start.sh

EXPOSE 30105
EXPOSE 30106

CMD ["/start.sh"]
