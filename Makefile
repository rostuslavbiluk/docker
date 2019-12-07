# Bitrix env commands
TAG   = 1.1.9
# Include dotenv variables
include .env
export

info: ## show env variable
	@echo $(PROJECT_HOST)
	@echo $(PROJECT_BACKUP_NAME_DB)

install-bitrix: ## Download db && files of bitrix and installiation
	docker-compose exec -T --user 1000 php \
		cp -avr ./install/shared ./$(PROJECT_NAME)/shared

#	docker-compose exec -T --user 1000 php wget \
#		--user $(PROJECT_BASIC_AUTH_LOGIN) \
#		--password $(PROJECT_BASIC_AUTH_PASSWORD) \
#		-c $(PROJECT_DATABASE_PATH) \
#		-P ./install/db

#	docker-compose exec -T --user 1000 php \
#	    gunzip -c ./install/$(PROJECT_BACKUP_NAME_DB) > ./public/install/mysql.backup.sql

	docker-compose exec -T --user 1000 php \
		cp ./install/.settings.php ./$(PROJECT_NAME)/shared/bitrix/

	docker-compose exec -T --user 1000 php \
		cp ./install/dbconn.php ./$(PROJECT_NAME)/shared/bitrix/php_interface/

#	docker exec -i $(DOCKER_PROJECT_PREFIX)mysql /usr/bin/mysql \
#		-u $(MYSQL_USER) -p$(MYSQL_ROOT_PASSWORD) -e "create database IF NOT EXISTS $(MYSQL_DATABASE)"

#	cat ./public/install/mysql.backup.sql | \
#		docker exec -i $(DOCKER_PROJECT_PREFIX)mysql /usr/bin/mysql \
#			-u $(MYSQL_USER) -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE)

download-mysql-dump: ## Download db on dev host
	docker-compose exec -T --user 1000 php wget \
		--no-check-certificate --content-disposition --no-cookies \
		--user $(PROJECT_BASIC_AUTH_LOGIN) \
		--password $(PROJECT_BASIC_AUTH_PASSWORD) \
		-c $(PROJECT_DATABASE_PATH) \
		-P ./install/db

	docker-compose exec -T --user 1000 php \
		gunzip -c ./install/db/$(PROJECT_BACKUP_NAME_DB) > ./public/install/db/mysql.backup.sql

update-mysql-dump: ## Download db on dev host and remove current db and update dump
	docker-compose exec -T --user 1000 php wget \
		--user $(PROJECT_BASIC_AUTH_LOGIN) \
		--password $(PROJECT_BASIC_AUTH_PASSWORD) \
		-c $(PROJECT_DATABASE_PATH) \
		-P ./install/db

	docker-compose exec -T --user 1000 php \
		gunzip -c ./install/db/$(PROJECT_BACKUP_NAME_DB) > ./public/install/db/mysql.backup.sql

	cat ./public/install/db/mysql.backup.sql | \
		docker exec -i $(DOCKER_PROJECT_PREFIX)mysql /usr/bin/mysql \
			-u $(MYSQL_USER) -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE)
