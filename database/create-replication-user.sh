#!/bin/bash

echo "Waiting for MySQL to start..."
until mysqladmin ping -h"localhost" --silent; do
    sleep 2
done

echo "MySQL is up! Configuring replication user..."

mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE USER IF NOT EXISTS '$REPLICATION_USER'@'%' IDENTIFIED BY '$REPLICATION_PASSWORD';
GRANT REPLICATION SLAVE ON *.* TO '$REPLICATION_USER'@'%';
FLUSH PRIVILEGES;
EOF

echo "Replication user created successfully!"
