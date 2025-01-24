#!/bin/bash

# If non-zero, then do
# if [ ! -z "${GLPI_DBHOST}" ] && [ ! -z "${GLPI_DBUSER}" ] && [ ! -z "${GLPI_DBPASSWORD}" ] && [ ! -z "${GLPI_DBDEFAULT}" ];
# then
#     echo "Creating config_db.php."
#     cat <<EOF >/var/www/html/glpi/config/config_db.php
#     <?php
#     class DB extends DBmysql {
#     public \$dbhost = '$GLPI_DBHOST';
#     public \$dbuser = '$GLPI_DBUSER';
#     public \$dbpassword = '$GLPI_DBPASSWORD';
#     public \$dbdefault = '$GLPI_DBDEFAULT';
#     public \$use_timezones = true;
#     public \$use_utf8mb4 = true;
#     public \$allow_myisam = false;
#     public \$allow_datetime = false;
#     public \$allow_signed_keys = false;
#     }    
# EOF
# fi

crond -b
nginx

exec "$@"