#!/bin/sh
set -e

echo "Preparing SQLite database..."
mkdir -p /app/database
touch /app/database/database.sqlite

export DB_CONNECTION=sqlite
export DB_DATABASE=/app/database/database.sqlite
export DB_HOST=
export DB_PORT=
export DB_USERNAME=
export DB_PASSWORD=

echo "Clearing cached config"
php artisan config:clear || true
php artisan cache:clear || true

echo "Running migrations"
php artisan migrate --force || echo "Migrations failed or skipped"

echo "Ensure storage link"
php artisan storage:link || true

echo "Starting PHP built-in webserver"
exec php -S 0.0.0.0:8000 -t /app/public
