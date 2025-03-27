FROM alpine as downloader

ARG GLPI_VERSION="10.0.17"

RUN mkdir /opt/src

WORKDIR /opt/src

ADD https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz /opt/src

RUN tar -xzf glpi-${GLPI_VERSION}.tgz -C /opt/src

### 

FROM php:8.3.0-fpm-alpine AS base

LABEL org.opencontainers.image.authors="Stanislav Chindyaev <chndv@tuta.io>"
LABEL org.opencontainers.image.version="10.0.17"

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
    && apk add nginx \
    && apk add runuser \
    # Установка зависимостей docker-entrypoint.sh
    && apk add --no-cache bash tzdata \
    # Очистка кешей apk
    && rm -rf /var/cache/apk/*


COPY --from=0 /opt/src/glpi /var/www/glpi

RUN chown -R www-data:www-data /var/www/glpi

WORKDIR /var/www/glpi

# Настройка пакетов
# Caddy
RUN apk add --no-cache caddy openrc
RUN rc-update add caddy default
COPY Caddyfile /etc/caddy/Caddyfile
## php, cron
RUN echo "session.cookie_httponly = on" >>/usr/local/etc/php/conf.d/php.ini \
    && echo "* * * * * /usr/local/bin/php /var/www/glpi/front/cron.php &>/dev/null" >>/etc/crontabs/www-data \
    && echo "0 * * * * /usr/local/bin/php /var/www/glpi/bin/console --no-interaction ldap:synchronize_users &>/dev/null" >> /etc/crontabs/www-data

EXPOSE 80/tcp

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD caddy run --config /etc/caddy/Caddyfile