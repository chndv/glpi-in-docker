#!/bin/bash

VERSION_GLPI=10.0.17

# Download GLPI source code
SRC_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/tags/${VERSION_GLPI} | jq .assets[0].browser_download_url | tr -d \")
TAR_GLPI=$(basename ${SRC_GLPI})
wget ${SRC_GLPI} -P /opt

# Устранение требования безопасности установщика GLPI
echo "session.cookie_httponly = on" >/usr/local/etc/php/conf.d/php.ini

# Установка временной зоны
echo "date.timezone = Europe/Moscow" > /usr/local/etc/php/conf.d/timezone.ini

# Установка задания cron GLPI
echo "* * * * * www-data /usr/local/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" >/etc/cron.d/glpi

# Настройка apache
echo -e "<VirtualHost *:80>\n\tDocumentRoot /var/www/html/glpi/public\n\n\t<Directory /var/www/html/glpi/public>\n\t\tRequire all granted\n\t\tRewriteEngine On\n\t\tRewriteCond %{REQUEST_FILENAME} !-f\n\t\n\t\tRewriteRule ^(.*)$ index.php [QSA,L]\n\t</Directory>\n\n\tErrorLog /var/log/apache2/error-glpi.log\n\tLogLevel warn\n\tCustomLog /var/log/apache2/access-glpi.log combined\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

a2enmod rewrite