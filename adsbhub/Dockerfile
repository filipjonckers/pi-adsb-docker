FROM balenalib/rpi-raspbian:stretch

WORKDIR /root

RUN apt-get update -qy \
    && apt-get install -qy socat inetutils-ping

COPY ./start.sh start.sh
RUN chmod +x start.sh

ENV DUMP1090_HOST=""
ENV DUMP1090_PORT=""

CMD ["/root/start.sh"]

