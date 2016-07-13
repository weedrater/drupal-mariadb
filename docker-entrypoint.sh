#!/bin/sh

set -eo pipefail

# Init config
if [ ! -f /etc/mysql/my.cnf ]; then
    mkdir -p /etc/mysql
    cp /opt/my.cnf /etc/mysql/my.cnf
    chmod 640 /etc/mysql/my.cnf
fi

# Init database
if [ ! -d /var/lib/mysql/mysql ]; then

    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        # Generate root password
        MYSQL_ROOT_PASSWORD="$(pwgen -1 10)"
        echo $MYSQL_ROOT_PASSWORD > /var/lib/mysql/.root_password
        chmod 600 /var/lib/mysql/.root_password
    fi

    if [ -z "$MYSQL_USER" ]; then
        MYSQL_USER="drupal"
    fi

    if [ -z "$MYSQL_PASSWORD" ]; then
        MYSQL_PASSWORD="drupal"
    fi

    if [ -z "$MYSQL_DATABASE" ]; then
        MYSQL_DATABASE="drupal"
    fi

    # Prepare init script
    cp /opt/init.sql /tmp/
    sed -i \
        -e 's/<<root_password>>/'"${MYSQL_ROOT_PASSWORD}"'/' \
        -e 's/<<user>>/'"${MYSQL_USER}"'/' \
        -e 's/<<password>>/'"${MYSQL_PASSWORD}"'/' \
        -e 's/<<database>>/'"${MYSQL_DATABASE}"'/' \
        /tmp/init.sql

    # Install database
    mysql_install_db --datadir=/var/lib/mysql
    chown 100:101 /var/lib/mysql
    mysqld --init-file=/tmp/init.sql >/dev/null 2>&1 &

    # Wait until mariadb initialized
    while ! mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD status >/dev/null 2>&1; do
        sleep 1
    done

    # Shutdown mariadb
    mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown

    # Remove init script
    rm /tmp/init.sql
fi

exec mysqld
