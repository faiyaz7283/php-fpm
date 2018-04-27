# Start with php:7.1-fpm-alpine base alpine image
FROM php:7.1-fpm-alpine

LABEL maintainer="faiyaz7283@gmail.com"

# Install bash and other helpful tools
RUN apk add --no-cache bash bash-completion sudo git nano curl man

# Add a group and user
RUN addgroup -g 1000 -S dcutil && \
    adduser -D -u 1000 -s /bin/bash -G dcutil dcutil

# Install GD extension
ENV GD_DEPS freetype libjpeg libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev \
            libxpm-dev libvpx-dev libjpeg-turbo-utils
RUN apk add --no-cache --virtual .gd-deps $GD_DEPS \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-xpm-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    && rm -rf /tmp/*

# Install memchached extension
ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev
RUN docker-php-source extract \
    && apk add --no-cache libmemcached-libs libmemcached zlib \
    && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps \
    && docker-php-source delete

# Install gettext
RUN docker-php-source extract \
    && apk add --no-cache gettext-dev \
    && docker-php-ext-install gettext \
    && rm -rf /tmp/* \
    && docker-php-source delete

# Install the pdo_mysql extension, mysqli
RUN docker-php-ext-install pdo_mysql mysqli opcache exif

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add vendor bin to your PATH
ENV PATH="${PATH}:${HOME}/.composer/vendor/bin:vendor/bin"

# Set /var/www as working directory
WORKDIR /var/www