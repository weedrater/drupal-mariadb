FROM alpine:3.4
MAINTAINER Wodby <admin@wodby.com>

RUN apk add --no-cache \
        pwgen \
        mariadb \
        mariadb-client

RUN rm /etc/mysql/my.cnf
RUN mkdir -p /var/run/mysqld /var/lib/mysql
RUN chown 100:101 /var/run/mysqld /var/lib/mysql

COPY init.sql /opt/
COPY my.cnf /opt/

VOLUME /var/lib/mysql

EXPOSE 3306

COPY docker-entrypoint.sh /usr/local/bin/
CMD "docker-entrypoint.sh"
