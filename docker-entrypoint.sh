#!/bin/bash
echo "date.timezone = \"${TZ}\"" > /usr/local/etc/php/conf.d/timezone.ini

crond -b -l 2
nginx

exec "$@"