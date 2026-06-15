#!/bin/bash
set -e

if [ -n "$PORT" ]; then
    sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf
    sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf
fi

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan package:discover --ansi || true

php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

php artisan migrate --force || true

php artisan storage:link || true

exec apache2-foreground
