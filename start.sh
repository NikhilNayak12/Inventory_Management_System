#!/bin/sh
set -e

echo "Container entrypoint: waiting for database..."

MAX_TRIES=30
i=0
while [ $i -lt $MAX_TRIES ]; do
  if php -r "try {\n    $dsn = (getenv('DB_CONNECTION') === 'pgsql') ? 'pgsql:host='.getenv('DB_HOST').';port='.getenv('DB_PORT').';dbname='.getenv('DB_DATABASE') : 'mysql:host='.getenv('DB_HOST').';port='.getenv('DB_PORT').';dbname='.getenv('DB_DATABASE');\n    new PDO($dsn, getenv('DB_USERNAME'), getenv('DB_PASSWORD'));\n    echo 'db_ok';\n  } catch (Exception $e) { exit(1);}" 2>/dev/null; then
    echo "Database is available"
    break
  fi
  i=$((i+1))
  echo "Waiting for DB... ($i/$MAX_TRIES)"
  sleep 2
done

if [ $i -ge $MAX_TRIES ]; then
  echo "Warning: database did not become available after $MAX_TRIES tries"
fi

echo "Running migrations (if any)"
php artisan migrate --force || echo "Migrations failed or skipped"

echo "Ensure storage link"
php artisan storage:link || true

echo "Starting PHP built-in webserver"
exec php -S 0.0.0.0:8000 -t /app/public
