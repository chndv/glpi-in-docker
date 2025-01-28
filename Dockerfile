FROM php:8.3.0-fpm-alpine AS base

LABEL org.opencontainers.image.authors="Stanislav Chindyaev <chndv@realweb.ru>"
LABEL org.opencontainers.image.version="10.0.17"

ARG GLPI_VERSION="10.0.17"

ENV TZ=Europe/Moscow

# Скачивание кода GLPI
ADD https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz /src/

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

WORKDIR /var/www/glpi

# Распаковка кода GLPI
RUN tar -xzf /src/glpi-${GLPI_VERSION}.tgz -C /var/www/ \
    && chown -R www-data:www-data /var/www/glpi \
    # Закомментировать эту строку, если нужен графический метод установки 
    && rm -f /var/www/glpi/install/install.php \
    && rm -rf /src

# Настройка пакетов
## nginx
COPY default.conf /etc/nginx/http.d/default.conf
## php, cron
RUN echo "session.cookie_httponly = on" >>/usr/local/etc/php/conf.d/php.ini \
    && echo "* * * * * /usr/local/bin/php /var/www/glpi/front/cron.php &>/dev/null" >>/etc/crontabs/www-data \
    && echo "0 * * * * /usr/local/bin/php /var/www/glpi/bin/console --no-interaction ldap:synchronize_users &>/dev/null" >> /etc/crontabs/www-data

EXPOSE 80/tcp

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD php-fpm