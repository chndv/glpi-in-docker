#!/bin/bash

echo "session.cookie_httponly = on" > /usr/local/etc/php/conf.d/php.ini

echo "* * * * * www-data php /var/www/html/glpi/front/cron.php &>/dev/null" > /etc/cron.d/glpi

if [ -f /var/www/html/glpi/config/glpicrypt.key ]; then
    rm /var/www/html/glpi/install/install.php
fi

apache2ctl -D FOREGROUND