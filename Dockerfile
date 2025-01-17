FROM php:8.3.15-apache-bookworm AS base

LABEL org.opencontainers.image.authors="chndv@tuta.io"

EXPOSE 80/tcp 443/tcp

ENV TZ="Europe/Moscow"

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    wget \
    libfreetype-dev \
    libicu-dev \
    libbz2-dev \
    libzip-dev \
    libldap2-dev \
    tzdata \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install ldap \
    && docker-php-ext-install opcache \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts /opt/scripts

RUN chmod +x /opt/scripts/entrypoint.sh && chmod +x /opt/scripts/glpi.sh && /opt/scripts/glpi.sh

ENTRYPOINT [ "/opt/scripts/entrypoint.sh" ]