# Use official PHP 8.2 image with FPM
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    default-mysql-client \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd \
    && docker-php-ext-enable pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install Node dependencies and build frontend
RUN npm install
RUN npm run production

# Create necessary directories and set permissions
RUN mkdir -p storage/logs storage/app storage/framework/cache storage/framework/sessions storage/framework/views
RUN mkdir -p bootstrap/cache
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Create public storage link
RUN php artisan storage:link || true

# Expose port 8000 for Render
EXPOSE 8000

# Start application and try to apply migrations at runtime
CMD ["sh", "-c", "php artisan migrate --force || true; php -S 0.0.0.0:8000 -t /app/public"]
