#!/bin/bash
set -e

# Fix nginx port - Railway inject PORT env variable
PORT=${PORT:-80}
sed -i "s/PORT_PLACEHOLDER/$PORT/g" /etc/nginx/nginx.conf

# Generate APP_KEY if not set
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force || true
fi

php artisan package:discover --ansi || true

# Clear stale build-time cache, then re-cache with runtime env
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Run migrations
timeout 60 php artisan migrate --force || true

# Storage link (ignore if already exists)
php artisan storage:link || true

# Fix storage permissions
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache || true
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache || true

php-fpm -D
exec nginx -g 'daemon off;'
