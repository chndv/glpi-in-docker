#!/usr/bin/bash

VERSION_GLPI=10.0.17
SRC_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/tags/${VERSION_GLPI} | jq .assets[0].browser_download_url | tr -d \")
TAR_GLPI=$(basename ${SRC_GLPI})

if [ "$(ls $TAR_GLPI)" ]
then
    echo "glpi is already download"
else
    wget ${SRC_GLPI}
    tar -xzf ${TAR_GLPI}
fi

docker build -t glpi:$VERSION_GLPI .