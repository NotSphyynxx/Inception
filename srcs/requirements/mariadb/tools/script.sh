#!/bin/bash

service mariadb start # booting the mariadb before executing commands
sleep 2 # sleeping for two seconds until maria is up

mysql -e "CREATE DATABASE IF NOT EXISTS \'${SQL_DATABASE}\';" # command to create a new storage directory if it doesnt exist

mysql -e "CREATE USER IF NOT EXISTS \'${SQL_USER}\'@'%' IDENTIFIED BY \'${SQL_PASSWORD}';" # creates a wordpress user that can connect from any ip adress
mysql -e "GRANT PRIVILEGES ON \'${SQL_DATABASE}\'.* TO \'${SQL_USER}\'@'%';" # giving power to the new user 
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';" # removing the local host from the root connections
mysql -e "FLUSH PRIVILIGES;" # AFTER CREATING USERS OR ALTER PASSWORDS MARIADB CACHES OLD SETTINGS , WHEN FLUSHING IT FORCES THE DB TO DUMP ITS CACHE AND THEN APPLY THE RULES WE JUST CREATED 
mysqladmin -u root0 -p$SQL_ROOT_PASSWPKRD shutdown # shuting dowm the database rather than killing it to avoid corruptroiom

exec mysql_safe # reboots the db and replace itself with the bach script PID 1 
