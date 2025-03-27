#!/bin/bash
echo "session.cookie_httponly = on" >>/usr/local/etc/php/conf.d/php.ini
echo "* * * * * /usr/local/bin/php /var/www/glpi/front/cron.php &>/dev/null" >>/etc/crontabs/www-data
echo "0 * * * * /usr/local/bin/php /var/www/glpi/bin/console --no-interaction ldap:synchronize_users &>/dev/null" >> /etc/crontabs/www-data
sed -i 's/pm.max_children = 5/pm.max_children = 10/g' /usr/local/etc/php-fpm.d/www.conf
echo "date.timezone = \"${TZ}\"" > /usr/local/etc/php/conf.d/timezone.ini

crond -b -l 2
php-fpm -D

exec "$@"