# Developer Documentation

This document outlines the internal mechanics, deployment strategies, and environment configurations for developers working on the Inception infrastructure.

### Setting Up the Environment
To deploy this project from scratch on a new Debian/Linux virtual machine:

1. **Prerequisites:** Docker and Docker Compose must be installed on the host machine.
2. **Domain Resolution:** You must edit the `/etc/hosts` file on the host machine to route the domain to the local loopback address. Add this line:
   `127.0.0.1 ilarhrib.42.fr`
3. **Storage Directories:** The physical host must have the target directories created for volume binding before deployment:
   `mkdir -p /home/ilarhrib/data/wordpress`
   `mkdir -p /home/ilarhrib/data/mariadb`
4. **Secrets and Configuration:** Create a `.env` file in the `srcs/` folder containing the following required variables:
   `SQL_DATABASE`, `SQL_USER`, `SQL_PASSWORD`, `SQL_ROOT_PASSWORD`, `ADMIN_USER`, `ADMIN_PASSWORD`, `ADMIN_EMAIL`, `WP_USER_LOGIN`, `WP_USER_PASSWORD`, `WP_USER_EMAIL`.

### Building and Launching
The infrastructure is orchestrated using Docker Compose but is strictly interfaced through the root `Makefile`.
* `make all`: Executes `docker-compose -f srcs/docker-compose.yml up -d --build`. This reads the `docker-compose.yml` file, builds the custom images from their respective `Dockerfiles`, establishes the internal `inception` network, and launches the containers in detached mode.

### Managing Containers and Volumes
Developers should use the following standard Docker commands for debugging and administration:
* **View real-time logs:** `docker logs -f <container_name>` (e.g., `docker logs wordpress`). This is critical for catching PHP or WP-CLI initialization errors.
* **Execute commands inside a container:** `docker exec -it <container_name> /bin/bash`. 
* **Inspect network configurations:** `docker network inspect inception`.
* **Prune unused resources:** `docker system prune -a` (clears dangling images and stopped containers).

### Data Storage and Persistence
This project ensures data persistence across container restarts and rebuilds. Data is not stored inside the container's writable layer.
* **Volume Strategy:** We use local Docker volumes with the `bind` option to map container directories directly to the host machine.
* **Database:** The MariaDB `/var/lib/mysql` directory is bound to `/home/ilarhrib/data/mariadb`.
* **Web Files:** The WordPress `/var/www/wordpress` directory is bound to `/home/ilarhrib/data/wordpress`.
* **Persistence Guarantee:** Because the data lives on the host VM, a developer can run `docker-compose down` (which deletes the containers) and rebuild them later. The newly built containers will instantly reattach to the host volumes and resume serving the exact same database and website state.