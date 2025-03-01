#!/bin/bash

echo "Waiting for MySQL to start..."
until mysqladmin ping -h"localhost" --silent; do
    sleep 2
done

echo "Testing master MySQL connection..."
until mysql -h "$HOST_URL" -u root -p"$MASTER_ROOT_PASSWORD" -e "SELECT 1;" --silent; do
    sleep 2
done

echo "MySQL is up! Configuring replication..."

mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='$MASTER_HOST_URL',
  SOURCE_PORT=$MASTER_PORT,
  SOURCE_USER='$REPLICATION_USER',
  SOURCE_PASSWORD='$REPLICATION_PASSWORD',
  SOURCE_SSL=1,
  SOURCE_LOG_FILE='mysql-bin.000001',
  SOURCE_LOG_POS=4;

START REPLICA;"

echo "Replication setup completed!"
