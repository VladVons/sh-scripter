FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt install -y --no-install-recommends mc htop \
        xauth x11-xserver-utils \
        firefox firefox-geckodriver;

#EXPOSE 8887

CMD firefox
