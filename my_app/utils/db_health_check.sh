#!/bin/sh

# Load env vars manually
if [ -f /env_vars.env ]; then
  export $(grep -v '^#' /.env | xargs)
fi
mariadb -h127.0.0.1 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" "$MYSQL_DATABASE" > /dev/null 2>&1 || exit 1
