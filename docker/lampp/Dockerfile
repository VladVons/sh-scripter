FROM debian
LABEL author="vladvons@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

ARG PKG \
    PKG_PHP_VER \
    PKG_PYTHON_VER \
    USER_ADMIN_PASSW

ENV PKG=$PKG \
    PKG_PHP_VER=$PKG_PHP_VER \
    PKG_PYTHON_VER=$PKG_PYTHON_VER \
    USER_ADMIN_PASSW=$USER_ADMIN_PASSW

#ADD mnt/www /mnt/
#VOLUME ["/var/www"]

EXPOSE 22 80

COPY ./script /script
WORKDIR /script
RUN ./main.sh build;
CMD ["./main.sh", "run"]
