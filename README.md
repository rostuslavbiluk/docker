# Готовое окружение Docker под Bitrix CMS

## Первичная настройка и установка

* Настраиваем переменные окружения. Для этого создаем файл `.env`, пример содержимого можно посмотреть в файле `.env.template`
```
# Settings for mysql connections
MYSQL_HOST=localhost 
MYSQL_DATABASE=project_db  
MYSQL_USER=project_user - не использовать root, так как в контейнере есть ошибка создания БД
MYSQL_PASSWORD=project_password - не использовать root, так как в контейнере есть ошибка создания БД
MYSQL_ROOT_PASSWORD=project_password

# It is unused. Just to remember
#ADMIN_LOGIN=login
#ADMIN_PASS=yourStrongPass

# Settings for docker run VirtualServer
DOCKER_PROJECT_PREFIX=project_
DOCKER_NGINX_PORT=80
DOCKER_SSL_PORT=443
DOCKER_MYSQL_PORT=3306
#INTERFACE=0.0.0.0
#DOCKER_NETWORK_IP=10.100.3.10
#DOCKER_NETWORK_SUBNET=10.100.3.0/24

# Settings for login basic auth
PROJECT_BASIC_AUTH_LOGIN=login_auth
PROJECT_BASIC_AUTH_PASSWORD=password_auth

# Settings for git repo
PROJECT_NAME=project_name
PROJECT_GIT=git@gitl.domain.com:project_name/project_name.git

# Settings for download backup dump db - dump must be expansion only .sql.gz
PROJECT_DATABASE_PATH=http://dev.domain.com/upload/bitrix.dev.sql.gz
PROJECT_BACKUP_NAME_DB=bitrix.dev.sql.gz
```
где: 
- **MYSQL_USER** - не использовать root, так как в контейнере есть ошибка создания БД (не обязательный параметр)
- **MYSQL_PASSWORD** - не использовать root, так как в контейнере есть ошибка создания БД (не обязательный параметр)
- **MYSQL_ROOT_PASSWORD** - не использовать root, так как в контейнере есть ошибка создания БД (не обязательный параметр)
- **DOCKER_PROJECT_PREFIX** - префикс проекта (не обязательный параметр)
-
- **PROJECT_BASIC_AUTH_LOGIN** - логин для авторизации через basic авторизацию на dev площадке (**обязательный** параметр)
- **PROJECT_BASIC_AUTH_PASSWORD** - пароль для авторизации через basic авторизацию на dev площадке (**обязательный** параметр)
-
- **PROJECT_NAME** - название проекта должно совпадать с названием репозитория (**обязательный** параметр)
- **PROJECT_GIT** - репозиторий с gitlab (**обязательный** параметр)
-
- **PROJECT_DATABASE_PATH** - полный путь к бекапу базы данных (**обязательный** параметр)
- **PROJECT_BACKUP_NAME_DB** - название бекапа базы данных, название покипируем с PROJECT_DATABASE_PATH (**обязательный** параметр)

все остальные параметры по усмотрению.

* Обновляем файлы `./public/install/.settings.php` и `./public/install/dbconn.php` (вносим правильный пароль, название БД, хост - название docker контейнера mysql)

* Настраиваем nginx конфиги для проекта. Для этого создаем файл `vhost.conf`, пример содержимого можно посмотреть в файле `vhost.template`

* Заходим в ./docker/nginx/vhost.conf строка 8 - исправляем `project_name` на название проекта (переменная в `./.env - PROJECT_NAME` ) и убираем комментарий #
```
#root /var/www/project_name/project_name;
```

* Запускаем команду установки репозитория проекта через bash скрипт (нужно предварительно проверить работу команды sh)
```
sh ./install/bash/project_install.sh
```

Если вы видите что-то подобное, все идет по плану =)
```
Run install project...

Cloning into 'repo'...
Checking out files: 100% (843/843), done.
```
Ждем выполнение команды и вывод сообщения:
```
Project init process done. Ready for start up.
```

Если вы видите вывод данного сообщения:
```
Project init process done. Ready for start up.
--Your need download core bitrix for dev project
```
Вам необходимо дополнительно скачать ядро Битрикс и добавить в shared/bitrix + создать симлинк внутри проекта на папку bitrix =)

* Запускаем докер с ключем `--build` для билда образов 
```
docker-compose up -d --build
```
Ждем выполнение команды, если docker скомпилился и запустился без ошибок идем дальше, если нет - исправляем ошибки =)

* По необходимости настраиваем файл hosts - добавляем `127.0.0.1	``project_name``.loc`
и дополнительно сделать рестарт `docker-compose`

* Если у вас нет необходимости работать с проектом по https, можно отключить данную надстройку в nginx:
необходимо закомментировать код в `vhost.conf`:
 ```
 с 1 по 5 строку
    #server{
    #    listen 80;
    #    server_name localhost;
    #    return 301 https://$host$request_uri;
    #}
 и с 14 по 18 строки
    #listen 443 ssl http2;
    #ssl on;
    #ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    #ssl_certificate_key /etc/ssl/certs/nginx-selfsigned.key;
    #ssl_verify_client off;
 ```
 и дополнительно сделать рестарт `docker-compose`