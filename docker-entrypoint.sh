#!/bin/bash

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force || true
fi

php artisan package:discover --ansi || true

php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

php artisan migrate --force || true

php artisan storage:link || true

PORT_TO_USE="${PORT:-80}"
exec php artisan serve --host=0.0.0.0 --port="${PORT_TO_USE}"
