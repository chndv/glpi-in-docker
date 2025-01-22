FROM php:8.3.15-fpm-alpine AS base

LABEL org.opencontainers.image.authors="Stanislav Chindyaev <chndv@tuta.io>"
LABEL org.opencontainers.image.version="10.0.17"

ARG GLPI_VERSION="10.0.17"

WORKDIR /var/www/html/glpi

# Скачивание
ADD https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz /src/

# Установка пакетов
RUN apk update \
    && apk add libzip-dev libpng-dev && docker-php-ext-install gd \
    && apk add icu-dev && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install opcache \
    && apk add openldap-dev && docker-php-ext-install ldap \
    && apk add nginx \
    && rm -rf /var/cache/apk/*

# Распаковка
RUN tar -xzf /src/glpi-${GLPI_VERSION}.tgz -C /var/www/html \
    && chown -R www-data:www-data /var/www/html/glpi \
    && rm -f /var/www/html/glpi/install/install.php \
    && rm -rf /src

# Настройка пакетов
## nginx
COPY default.conf /etc/nginx/http.d/default.conf
## php, cron
RUN echo "session.cookie_httponly = on" >>/usr/local/etc/php/conf.d/php.ini \
    && echo "* * * * * www-data /usr/local/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" >>/etc/crontabs/root

EXPOSE 80/tcp

CMD crond -b && php-fpm -DR && nginx -g 'daemon off;'