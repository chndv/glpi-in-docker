FROM php:8.3.15-apache-bookworm AS base

LABEL org.opencontainers.image.authors="Stanislav Chindyaev <chndv@tuta.io>"
LABEL org.opencontainers.image.version="10.0.17"

ENV TZ="Europe/Moscow"

COPY ./scripts /opt/scripts

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    wget \
    libfreetype-dev \
    libicu-dev \
    libbz2-dev \
    libzip-dev \
    libldap2-dev \
    tzdata \
    cron \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install ldap \
    && docker-php-ext-install opcache \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && chmod +x /opt/scripts/entrypoint.sh \
    && chmod +x /opt/scripts/glpi.sh \
    && /opt/scripts/glpi.sh

EXPOSE 80/tcp 443/tcp

CMD /opt/scripts/entrypoint.sh && exec apache2-foreground