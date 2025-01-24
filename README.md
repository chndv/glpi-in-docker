# glpi-in-docker

В данном репозипории находятся файлы необходимые для сборки и контейнера с [GLPI](https://github.com/glpi-project/glpi).

1. Склонировать репозиторий.

    `git clone http://github.com/chndv/glpi-in-docker.git`

2. Запустить контейнер.
    
    `docker compose up -d --build`
    
3. Выполнить настройку GLPI через CLI.
    
    Например, такой командой можно инициализировать базу данных `docker compose exec -it glpi runuser -u www-data -- php bin/console db:install --db-host=db --db-name=glpi --db-user=root --db-password=password --default-language=en_US --no-telemetry --no-interaction`

Далее всё зависит от сценария использования.

> [!CAUTION]
> В этой версии контейнера удалены файлы запуска GLPI Installation Wizard, то есть графический метод установки/обновления будет недоступен.
