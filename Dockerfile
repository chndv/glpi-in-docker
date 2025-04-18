FROM alpine as downloader

ARG GLPI_VERSION="10.0.18"

RUN mkdir /opt/src

WORKDIR /opt/src

ADD https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz /opt/src

RUN tar -xzf glpi-${GLPI_VERSION}.tgz -C /opt/src

FROM php:8.3.0-fpm-alpine AS base

LABEL org.opencontainers.image.authors="Stanislav Chindyaev <chndv@tuta.io>"
LABEL org.opencontainers.image.version="10.0.18"

ENV TZ=Europe/Moscow

# Установка пакетов
RUN \
    apk add libzip-dev libpng-dev && docker-php-ext-install gd \
    && apk add icu-dev && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install opcache \
    && apk add openldap-dev && docker-php-ext-install ldap \
    && apk add --no-cache bash \
    tzdata \
    supervisor \
    runuser \
    caddy \
    && rm -rf /var/cache/apk/*

COPY --from=downloader --chown=www-data:www-data /opt/src/glpi /var/www/glpi

COPY --chown=caddy:caddy ./configs/caddy/Caddyfile /etc/caddy/Caddyfile

COPY --chown=root:root ./configs/supervisor.d /etc/supervisor.d

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 80/tcp

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]