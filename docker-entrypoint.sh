#!/bin/bash

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force || true
fi

php artisan package:discover --ansi || true
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true
timeout 60 php artisan migrate --force || true
php artisan storage:link || true

php-fpm -D
exec nginx -g 'daemon off;' -e /dev/stderr
