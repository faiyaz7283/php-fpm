# Start with php:5.6-fpm-alpine base alpine image
FROM php:5.6-fpm-alpine

LABEL maintainer="faiyaz7283@gmail.com"

# Dependencies for php GD
ENV GD_DEPS freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev
RUN docker-php-source extract \
    && apk add --no-cache --virtual .gd-deps $GD_DEPS \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    && rm -rf /tmp/* \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-source delete

# Install memchached extension
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN docker-php-source extract \
    && apk add --no-cache libmemcached-libs libmemcached zlib \
    && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps \
    && docker-php-source delete

 # Install apcu extension
 RUN docker-php-source extract \
     && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
     && pecl install apcu-4.0.11 \
     && docker-php-ext-enable apcu \
     && rm -rf /tmp/* \
     && apk del .phpize-deps \
     && docker-php-source delete

# Install the pdo_mysql extension, mysqli
RUN docker-php-ext-install pdo_mysql mysqli

# Set /var/www as working directory
WORKDIR /var/www