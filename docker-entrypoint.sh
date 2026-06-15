#!/bin/bash

export APACHE_PORT="${PORT:-80}"

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force || true
fi

php artisan package:discover --ansi || true

php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

php artisan migrate --force || true

php artisan storage:link || true

exec apache2-foreground
