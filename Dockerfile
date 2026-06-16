FROM php:8.0-fpm

RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev libzip-dev zip unzip libgmp-dev nginx \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip gmp

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

RUN mkdir -p bootstrap/cache storage/framework/cache storage/framework/sessions \
    storage/framework/views storage/logs storage/app/public \
    && chmod -R 775 bootstrap/cache storage

ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --optimize-autoloader --no-dev --no-interaction --ignore-platform-reqs

# Build frontend
RUN npm install && export NODE_OPTIONS=--openssl-legacy-provider && npm run prod

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

CMD ["docker-entrypoint.sh"]
