FROM balenalib/rpi-raspbian:buster

ENTRYPOINT []

RUN apt-get update && apt-get install -qy apt-utils wget
RUN wget https://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_4.0_all.deb \
  && sudo dpkg -i piaware-repository_4.0_all.deb \
  && apt-get update \
  && apt-get install -qy piaware \
  && sudo piaware-config allow-auto-updates yes \
  && sudo piaware-config allow-manual-updates yes

COPY ./piaware.conf /etc/piaware.conf
COPY ./start.sh start.sh
RUN chmod +x start.sh

EXPOSE 30105
EXPOSE 30106

CMD ["/start.sh"]
