# Start with php7.1-fpm base alpine image
FROM php:5-fpm-alpine

LABEL maintainer="faiyaz7283@gmail.com"

# Install the missing pdo_mysql extension
RUN docker-php-ext-install pdo_mysql

# Set /var/www as working directory
WORKDIR /var/www
