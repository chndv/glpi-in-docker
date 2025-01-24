#!/usr/bin/bash

GLPI_DBHOST=db
GLPI_DBUSER=root
GLPI_DBPASSWORD=password
GLPI_DBDEFAULT=glpi
GLPI_USE_TIMEZONES=
GLPI_USE_UTF8MB4=
GLPI_ALLOW_MYISAM=
GLPI_ALLOW_DATETIME=
GLPI_ALLOW_SIGNED_KEYS=

# If non-zero, then do
if [ ! -z "${GLPI_DBHOST}" ] && [ ! -z "${GLPI_DBUSER}" ] && [ ! -z "${GLPI_DBPASSWORD}" ] && [ ! -z "${GLPI_DBDEFAULT}" ];
then
cat <<EOF >/var/www/html/glpi/config/config_db.php
<?php
class DB extends DBmysql {
   public \$dbhost = '$GLPI_DBHOST';
   public \$dbuser = '$GLPI_DBUSER';
   public \$dbpassword = '$GLPI_DBPASSWORD';
   public \$dbdefault = '$GLPI_DBDEFAULT';
   public \$use_timezones = true;
   public \$use_utf8mb4 = true;
   public \$allow_myisam = false;
   public \$allow_datetime = false;
   public \$allow_signed_keys = false;
}    
EOF
fi