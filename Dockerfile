FROM alpine:3.4
MAINTAINER Wodby <admin@wodby.com>

RUN apk add --no-cache \
        bash \
        tzdata \
        pwgen \
        mariadb \
        mariadb-client

ENV BASH_SOURCE /bin/bash

RUN mkdir -p /var/run/mysqld /var/lib/mysql
RUN chown 100:101 /var/run/mysqld /var/lib/mysql

RUN mkdir /docker-entrypoint-initdb.d
COPY my.cnf /etc/mysql/my.cnf
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /var/lib/mysql
EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
