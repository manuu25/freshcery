#!/bin/sh
set -e

# --- 1. Bind Apache to Render's port -------------------------------------
# Render injects $PORT (defaults to 10000). Apache listens on 80 out of the box,
# so rewrite both the global Listen directive and the default vhost to $PORT.
PORT="${PORT:-80}"
sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i "s/\*:80/*:${PORT}/" /etc/apache2/sites-available/000-default.conf

# --- 2. Auto-seed the PostgreSQL database on first boot -------------------
# Runs only when DB_DRIVER=pgsql and the schema isn't there yet (idempotent:
# it checks for the "users" table and never re-imports over existing data).
if [ "$DB_DRIVER" = "pgsql" ] && [ -n "$DB_HOST" ]; then
  export PGPASSWORD="$DB_PASS"
  DB_PORT="${DB_PORT:-5432}"

  # Wait for the database to accept connections (up to ~30s).
  i=0
  while [ "$i" -lt 30 ]; do
    if pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" >/dev/null 2>&1; then
      break
    fi
    i=$((i + 1))
    sleep 1
  done

  EXISTS=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
    -tAc "SELECT to_regclass('public.users');" 2>/dev/null || true)

  if [ "$EXISTS" != "users" ]; then
    echo "[entrypoint] Seeding database from freshcery.pg.sql ..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
      -f /var/www/html/freshcery.pg.sql || echo "[entrypoint] WARN: seeding failed"
  else
    echo "[entrypoint] Database already seeded, skipping."
  fi
fi

exec "$@"
