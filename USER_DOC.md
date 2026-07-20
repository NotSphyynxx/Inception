# User Documentation

This guide provides instructions for end users and administrators to interact with the Inception web stack.

### Services Provided
This stack provides a fully operational, secure WordPress website. It consists of three main services running silently in the background:
* **NGINX:** The web server handling all incoming traffic securely over HTTPS (TLSv1.2/v1.3).
* **WordPress (PHP-FPM):** The backend application serving the website content and admin dashboard.
* **MariaDB:** The database securely storing all website posts, settings, and user accounts.

### Starting and Stopping the Project
The project is controlled via the `Makefile` located at the root of the repository. Open a terminal and run the following commands:
* **To start the project:** `make` (or `make all`). This will initialize the database, configure WordPress, and launch the website.
* **To stop the project:** `make stop` (pauses the services) or `make down` (stops and removes the containers while preserving your data).
* **To reset the project:** `make fclean` (WARNING: This destroys the containers, networks, and wipes all saved data/volumes).

### Accessing the Website and Administration Panel
Once the project is running, you can access the platform through any web browser:
* **Main Website:** Navigate to `https://ilarhrib.42.fr`
* **Administration Panel:** Navigate to `https://ilarhrib.42.fr/wp-admin`

*(Note: Because the site uses a self-signed SSL certificate, your browser may show a security warning. You must click "Advanced" and "Accept the Risk" to proceed to the site).*

### Locating and Managing Credentials
All passwords, database names, and user logins are managed in a single, hidden configuration file named `.env`, located in the `srcs/` directory. 
To change a credential, you must edit this `.env` file, run `make fclean` to wipe the old data, and run `make all` to deploy the site with the new credentials. 

### Checking Service Status
To verify that all parts of the infrastructure are running correctly, open a terminal and run:
`docker ps`
You should see three containers (`nginx`, `wordpress`, and `mariadb`) listed with a status of `Up`. If any container says `Restarting` or is missing, a critical error has occurred.