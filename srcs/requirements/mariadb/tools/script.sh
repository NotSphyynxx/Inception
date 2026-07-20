#!/bin/bash

# Check if the specific WordPress database exists instead of the system files
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    echo "Initializing MariaDB for the first time..."
    
    # Start the daemon in the background temporarily
    mysqld_safe &
    
    # Wait until it is actually ready to accept connections
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # Inject the SQL configuration securely
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    mysql -u root -p"${SQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    # Shut down the background process cleanly
    mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
else
    echo "MariaDB is already configured."
fi

# Launch the daemon in the foreground as PID 1
echo "Starting MariaDB..."
exec mysqld_safe