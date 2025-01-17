FROM php:8.3.15-apache-bookworm AS base

LABEL org.opencontainers.image.authors="chndv@tuta.io"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype-dev \
    libicu-dev \
    libbz2-dev \
    libzip-dev \
    libldap2-dev \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install ldap \
    && docker-php-ext-install opcache \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite

COPY --chown=www-data:www-data ./glpi /var/www/html/glpi

COPY 000-default.conf /etc/apache2/sites-available/

COPY entrypoint.sh /opt/

RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

EXPOSE 80/tcp 443/tcp