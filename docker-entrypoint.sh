#!/bin/bash
sed -i 's/pm.max_children = 5/pm.max_children = 10/g' /usr/local/etc/php-fpm.d/www.conf
echo "date.timezone = \"${TZ}\"" > /usr/local/etc/php/conf.d/timezone.ini

crond -b -l 2
nginx

exec "$@"