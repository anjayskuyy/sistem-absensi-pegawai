#!/bin/bash

echo ">>> STEP: key:generate"
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force || true
fi

echo ">>> STEP: package:discover"
php artisan package:discover --ansi || true

echo ">>> STEP: config:cache"
php artisan config:cache || true
echo ">>> STEP: route:cache"
php artisan route:cache || true
echo ">>> STEP: view:cache"
php artisan view:cache || true

echo ">>> STEP: migrate"
timeout 60 php artisan migrate --force || echo ">>> MIGRATE FAILED OR TIMED OUT"

echo ">>> STEP: storage:link"
php artisan storage:link || true

echo ">>> STEP: starting server"
PORT_TO_USE="${PORT:-80}"
echo ">>> PORT_TO_USE=${PORT_TO_USE}"
exec php artisan serve --host=0.0.0.0 --port="${PORT_TO_USE}"
