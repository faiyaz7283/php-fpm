# Start with php:5.6-fpm-alpine base alpine image
FROM php:5.6-fpm-alpine

LABEL maintainer="faiyaz7283@gmail.com"

# Install the missing pdo_mysql extension
RUN docker-php-ext-install pdo_mysql mysqli

# Install memchached extension
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe \
    && apk add --no-cache --update libmemcached \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached-2.2.0 \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && rm -rf /usr/share/php7 \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps

# Set /var/www as working directory
WORKDIR /var/www
