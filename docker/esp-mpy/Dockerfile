FROM ubuntu

ENV TZ=Europe/Kiev
ARG DEBIAN_FRONTEND=noninteractive

COPY ./esp-mpy/script /home/esp/esp-sdk/script

WORKDIR /home/esp/esp-sdk/script

RUN ./install.sh;
