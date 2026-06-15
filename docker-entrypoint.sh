#!/bin/bash
set -e

# Railway provides PORT env var, Apache default is 80 — make Apache listen on $PORT
if [ -n "$PORT" ]; then
    sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf
    sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf
fi

# Generate app key if not set (first run)
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

# Cache config and routes for performance
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Run database migrations (and seed Voyager on first deploy)
php artisan migrate --force || true

# Create storage symlink (public/storage -> storage/app/public)
php artisan storage:link || true

# Start Apache in foreground
exec apache2-foreground
