#!/usr/bin/env bash
# Generates a local .env with random safe credentials.
# The variable NAMES match Coolify's Environment Variables panel exactly,
# so the same compose deploys identically in both places.
# Values are random here; in Coolify you paste your own values under the same names.
# NOTE: .env is gitignored and must never be committed.
set -euo pipefail

gen() { tr -dc 'A-Za-z0-9' </dev/urandom | head -c 40 || true; }

HOSTNAME="${1:-seatable.local}"
ADMIN_EMAIL="${2:-admin@example.invalid}"

cat > .env <<EOF
# --- SeaTable image ---
SEATABLE_IMAGE=seatable/seatable-developer:6.2.1

# --- server identity ---
SEATABLE_SERVER_HOSTNAME=${HOSTNAME}
SEATABLE_SERVER_PROTOCOL=https
SEATABLE_ADMIN_EMAIL=${ADMIN_EMAIL}
SEATABLE_ADMIN_PASSWORD=$(gen)
TIME_ZONE=Europe/Berlin

# --- database / cache / secrets ---
MARIADB_PASSWORD=$(gen)
# There is no separate MARIADB_ROOT_PASSWORD: MariaDB root and SeaTable both use
# MARIADB_PASSWORD, so they can never drift out of sync.
REDIS_PASSWORD=$(gen)
JWT_PRIVATE_KEY=$(gen)
SECRET_KEY=$(gen)

# --- optional bootstrap toggles ---
# Set to 1 only if a MariaDB upgrade backup fails with a TLS/self-signed cert error.
MARIADB_DISABLE_UPGRADE_BACKUP=
EOF

echo "Wrote .env for ${HOSTNAME}. Keep it private."
