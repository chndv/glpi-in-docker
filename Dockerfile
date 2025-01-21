# FROM php:8.3.15-apache-bookworm AS base
FROM php:8.3.15-fpm-alpine AS base

LABEL org.opencontainers.image.authors="Stanislav Chindyaev <chndv@tuta.io>"
LABEL org.opencontainers.image.version="10.0.17"

ENV TZ="Europe/Moscow"

COPY ./scripts /opt/scripts

ADD https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz /opt/

# Установка PHP-дополнений
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
    && rm -rf /var/cache/apk/* \
    && chmod +x /opt/scripts/entrypoint.sh

EXPOSE 80/tcp

ENTRYPOINT /opt/scripts/entrypoint.sh && php-fpm
