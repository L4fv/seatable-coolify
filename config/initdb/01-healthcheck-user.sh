#!/bin/bash
# Creates the MariaDB health check user and credentials file required by
# the official healthcheck.sh. Runs only on first init of an empty datadir.
set -euo pipefail

PW=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20 || true)

mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "
CREATE USER IF NOT EXISTS 'healthcheck'@'localhost' IDENTIFIED BY '${PW}';
CREATE USER IF NOT EXISTS 'healthcheck'@'127.0.0.1' IDENTIFIED BY '${PW}';
CREATE USER IF NOT EXISTS 'healthcheck'@'::1' IDENTIFIED BY '${PW}';
CREATE USER IF NOT EXISTS 'healthcheck'@'%' IDENTIFIED BY '${PW}';
GRANT USAGE ON *.* TO 'healthcheck'@'localhost';
GRANT USAGE ON *.* TO 'healthcheck'@'127.0.0.1';
GRANT USAGE ON *.* TO 'healthcheck'@'::1';
GRANT USAGE ON *.* TO 'healthcheck'@'%';
FLUSH PRIVILEGES;"

printf "[mariadb-client]\nport=3306\nsocket=/run/mysqld/mysqld.sock\nuser=healthcheck\npassword=%s\nprotocol=tcp\n" "${PW}" > /var/lib/mysql/.my-healthcheck.cnf

echo "healthcheck user created"
