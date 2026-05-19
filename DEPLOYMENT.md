# Deployment Guide

This project is ready to deploy once you provide production environment values and point a web server at the `public/` directory.

## 1. Set production environment values

Update [`.env`](.env) with your live values:

- `APP_ENV=production`
- `APP_DEBUG=false`
- `APP_URL=https://your-domain.example`
- `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
- mail / SMTP settings if the app sends email

## 2. Install dependencies on the server

```bash
composer install --no-dev --optimize-autoloader
npm install
npm run production
```

## 3. Prepare Laravel

```bash
php artisan key:generate --force
php artisan storage:link
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force
```

If you need seed data:

```bash
php artisan db:seed --force
```

## 4. Web server

Point your web server document root to `public/`.

- Use the nginx sample in [deploy/nginx.conf.example](deploy/nginx.conf.example)
- Or use the Apache sample in [deploy/apache-vhost.conf.example](deploy/apache-vhost.conf.example)

## 5. Queue and scheduler

If you use queues, run a queue worker under Supervisor.

- Use [deploy/supervisor.conf.example](deploy/supervisor.conf.example)

If you use scheduled tasks, add a cron job:

- Use [deploy/cron.example](deploy/cron.example)

## 6. Permissions

Make sure these directories are writable by the web server user:

- `storage/`
- `bootstrap/cache/`

## 7. Verification

After deployment, verify:

- homepage loads
- login works
- orders can be created
- logs are clean in `storage/logs/`