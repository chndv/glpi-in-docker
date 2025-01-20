#!/bin/bash
set -e

VERSION_GLPI=10.0.17
TAR_GLPI=glpi-$VERSION_GLPI.tgz

# Если GLPI уже установлен, то пропустить установку, если нет, то установить

if [ -d /var/www/html/glpi/bin ]; then
    echo "GLPI уже установлен"
    rm -rf /opt/${TAR_GLPI}
else
    tar -xzf /opt/${TAR_GLPI} -C /var/www/html
    chown -R www-data:www-data /var/www/html/glpi
    rm -rf /opt/${TAR_GLPI}
fi
