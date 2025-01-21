#!/bin/sh
set -e

VERSION_GLPI=10.0.17
TAR_GLPI=glpi-$VERSION_GLPI.tgz

# Если GLPI уже установлен, то пропустить установку, если нет, то установить
if [ -d /var/www/html/glpi/bin ]; then
    echo "GLPI уже установлен, пропускаю распаковку"
    rm -rf /opt/${TAR_GLPI}
else
    echo "Распаковка GLPI в /var/www/html/glpi"
    tar -xzf /opt/${TAR_GLPI} -C /var/www/html
    chown -R www-data:www-data /var/www/html/glpi
fi

# Настройка веб-сервера
cat <<'EOF' >/etc/nginx/http.d/default.conf
server {
    listen 80;

    server_name glpi.localhost;

    root /var/www/html/glpi/public;

    location / {
        try_files $uri /index.php$is_args$args;
    }

    location ~ ^/index\.php$ {
        # the following line needs to be adapted, as it changes depending on OS distributions and PHP versions
        fastcgi_pass 127.0.0.1:9000;

        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
EOF

# Устранение требования безопасности установщика GLPI
echo "session.cookie_httponly = on" >>/usr/local/etc/php/conf.d/php.ini

# Установка задания cron GLPI
echo "* * * * * www-data /usr/local/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" >>/etc/crontabs/root

crond

nginx
