#!/bin/bash
# Generates safe credentials for SeaTable on Coolify.
# Special characters excluded because they break the MariaDB healthcheck and
# Python libs during initialization.
set -euo pipefail

gen() {
  # 40 chars, lowercase+uppercase+digits only
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 40 || true
}

ADMIN_PASSWORD=$(gen)
MARIADB_PASSWORD=$(gen)
REDIS_PASSWORD=$(gen)
JWT_PRIVATE_KEY=$(gen)
SECRET_KEY=$(gen)

cat <<EOF
SEATABLE_IMAGE=seatable/seatable-developer:6.2.1
SEATABLE_SERVER_HOSTNAME=seatable.klap.top
SEATABLE_SERVER_PROTOCOL=https
SEATABLE_ADMIN_EMAIL=admin@klap.top
SEATABLE_ADMIN_PASSWORD=${ADMIN_PASSWORD}
MARIADB_PASSWORD=${MARIADB_PASSWORD}
REDIS_PASSWORD=${REDIS_PASSWORD}
JWT_PRIVATE_KEY=${JWT_PRIVATE_KEY}
SECRET_KEY=${SECRET_KEY}
TIME_ZONE=America/Argentina/Buenos_Aires
EOF
