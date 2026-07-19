#!/bin/bash

# creating the dir where the .pid will be stored
mkdir -p /run/php

# Check if the WordPress configuration file already exists in the shared volume
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Configuring WordPress..."

    # Download core WordPress files and allowing root so it wont refuse since it refuses to download as root (the container is in root mode)
    wp core download --allow-root --path=/var/www/wordpress # downloading it in the shared volume between nginx and wp

    # Generate the configuration file linked to the MariaDB container
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306 --path=/var/www/wordpress # values will be fetched fro the .env file and we used dns name instead of ip

    # configuring the wordpress table in the mariadb 
    wp core install --allow-root \
        --url=ilarhrib.42.fr \
        --title="Inception" \
        --admin_user=$SQL_USER \
        --admin_password=$SQL_PASSWORD \
        --admin_email=admin@ilarhrib.42.fr \
        --path=/var/www/wordpress # configuring the website url, its title, admin user, its password , email and the path where wp will install 

    # Create the secondary standard user with no admin power
    wp user create --allow-root $WP_USER_LOGIN $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD --role=author \
        --path=/var/www/wordpress
fi

# Replace the current Bash process with the PHP-FPM daemon executing in the foreground
exec /usr/sbin/php-fpm7.4 -F