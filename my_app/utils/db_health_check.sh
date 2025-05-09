#!/bin/sh
mariadb -h127.0.0.1 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" "$MYSQL_DATABASE" > /dev/null 2>&1 || exit 1
