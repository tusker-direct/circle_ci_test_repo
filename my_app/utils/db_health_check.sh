#!/bin/sh

# Load env vars manually
if [ -f /.env ]; then
  export $(grep -v '^#' /.env | xargs)
fi

# Debug: print values (be cautious with secrets)
echo "MYSQL_USER=$MYSQL_USER"
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD"
echo "MYSQL_DATABASE=$MYSQL_DATABASE"

# Actual health check
mariadb -h127.0.0.1 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" "$MYSQL_DATABASE" > /dev/null 2>&1 || exit 1
