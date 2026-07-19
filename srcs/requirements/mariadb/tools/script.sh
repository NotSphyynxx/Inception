#!/bin/bash

service mariadb start # booting the mariadb before executing commands
sleep 2 # sleeping for two seconds until maria is up

mysql -e "CREATE DATABASE IF NOT EXISTS \'${SQL_DATABASE}\';"

