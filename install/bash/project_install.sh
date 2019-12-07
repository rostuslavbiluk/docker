#!/bin/bash
source ./.env
echo
echo 'Run install project...';
echo

if [ ! -f "$PWD/install/db/$PROJECT_BACKUP_NAME_DB" ]; then
echo 'Run scripts download database...'
echo

#wget --no-check-certificate --content-disposition --no-cookies --trust-server-names --user $PROJECT_BASIC_AUTH_LOGIN --password $PROJECT_BASIC_AUTH_PASSWORD -c "$PROJECT_DATABASE_PATH" -P $PWD/install/db
cd install/db/

curl -k -L -o ./$PROJECT_BACKUP_NAME_DB -u$PROJECT_BASIC_AUTH_LOGIN:$PROJECT_BASIC_AUTH_PASSWORD $PROJECT_DATABASE_PATH
gunzip -c ./$PROJECT_BACKUP_NAME_DB > ./mysql.backup.sql

cd ../../
echo
echo 'Successfully download database...'
echo
sleep 2
fi

cd public/

if [ ! -d "$PWD/$PROJECT_NAME" ]; then
echo $PROJECT_GIT
git clone --config core.symlinks=true $PROJECT_GIT
echo
fi

sleep 2
cd $PROJECT_NAME/
echo 'Init submodule and update...'
echo
git submodule update --remote --init --recursive

if [ ! -d "$PWD/shared" ]; then
sleep 2
echo
echo 'Copy shared folder...'
mkdir -p $PWD/shared/
cp -rf ../../install/shared $PWD/
cp -rf ../../install/.settings.php $PWD/$PROJECT_NAME/bitrix/
cp -rf ../../install/dbconn.php $PWD/$PROJECT_NAME/bitrix/php_interface/
echo
fi

echo 'Project init process done. Ready for start up.'

if [ ! -f "$PWD/$PROJECT_NAME/bitrix/index.php" ]; then
echo '--Your need download core bitrix for dev project'
fi
echo