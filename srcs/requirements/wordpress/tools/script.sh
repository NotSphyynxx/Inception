#!/bin/bash

# Create the folder PHP needs to run
mkdir -p /run/php

# Check if wp-config.php exists. If not, auto-install.
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "WordPress not found. Waiting for MariaDB to boot..."
    
    # Give MariaDB 10 seconds to fully initialize and accept network connections
    sleep 10
    
    # Download WordPress
    wp core download --allow-root --path='/var/www/wordpress'
    
# Generate wp-config.php
    wp config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb:3306 \
        --path='/var/www/wordpress'
    
    # Install WordPress (Uses the ADMIN variables)
    wp core install --allow-root \
        --url=ilarhrib.42.fr \
        --title="Inception" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" \
        --path='/var/www/wordpress'
        
    # Create the secondary user (Uses the WP_USER variables)
    wp user create --allow-root \
        "$WP_USER_LOGIN" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --path='/var/www/wordpress'

fi

# Launch PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F