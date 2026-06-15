#!/bin/bash
set -x

if [ -n "$PORT" ]; then
    sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
    sed -i "s/:80>/:${PORT}>/g" /etc/apache2/sites-available/000-default.conf
fi

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan package:discover --ansi || true
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true
timeout 60 php artisan migrate --force || true
php artisan storage:link || true

exec apache2-foreground
