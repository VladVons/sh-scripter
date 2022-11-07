FROM debian

LABEL author="vladvons@gmail.com"
LABEL version="1.0.1, 2022.11.06"

ARG DEBIAN_FRONTEND=noninteractive

ARG PKG \
    PKG_PHP_VER \
    PKG_PYTHON_VER \
    PKG_MARIADB \
    USER_ADMIN_PASSW

ENV PKG=$PKG \
    PKG_PHP_VER=$PKG_PHP_VER \
    PKG_PYTHON_VER=$PKG_PYTHON_VER \
    PKG_MARIADB=$PKG_MARIADB \
    USER_ADMIN_PASSW=$USER_ADMIN_PASSW

ADD mnt/www /var/www
VOLUME ["/var/www"]

EXPOSE 22 80 3306

COPY ./script /script
WORKDIR /script

# only on build
RUN ./main.sh build;

# only on run 
CMD ["./main.sh", "run"]
