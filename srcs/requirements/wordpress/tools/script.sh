#!/bin/bash

# Ensure the PID directory exists for PHP-FPM
mkdir -p /run/php

# Check if the WordPress configuration file already exists in the shared volume
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Configuring WordPress..."

    # Download core WordPress files
    wp core download --allow-root --path=/var/www/wordpress

    # Generate the configuration file linked to the MariaDB container
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306 --path=/var/www/wordpress

    # Execute the database population and administrative user creation
    wp core install --allow-root \
        --url=ilarhrib.42.fr \
        --title="Inception" \
        --admin_user=$SQL_USER \
        --admin_password=$SQL_PASSWORD \
        --admin_email=admin@ilarhrib.42.fr \
        --path=/var/www/wordpress

    # Create the secondary standard user required by the rubric
    wp user create --allow-root $WP_USER_LOGIN $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD --role=author \
        --path=/var/www/wordpress
fi

# Replace the current Bash process with the PHP-FPM daemon executing in the foreground
exec /usr/sbin/php-fpm7.4 -F