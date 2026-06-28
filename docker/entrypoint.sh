#!/bin/sh
set -e

# Render injects $PORT (defaults to 10000). Apache listens on 80 out of the box,
# so rewrite both the global Listen directive and the default vhost to $PORT.
PORT="${PORT:-80}"
sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i "s/\*:80/*:${PORT}/" /etc/apache2/sites-available/000-default.conf

exec "$@"
