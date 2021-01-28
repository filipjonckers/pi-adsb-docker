FROM balenalib/rpi-raspbian:buster

WORKDIR /root

RUN apt-get update -qy \
    && apt-get install -qy socat

COPY ./start.sh start.sh
RUN chmod +x start.sh

ENV CUSTOM_PORT=""

CMD ["/root/start.sh"]

