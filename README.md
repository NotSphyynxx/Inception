*This project has been created as part of the 42 curriculum by Ismail Larhrib (ilarhrib).*

## Description
Inception is a system administration and devops project that introduces Docker and containerization. The goal of this project is to broaden knowledge of system administration by deploying a highly available, isolated, and secure LEMP-like stack (Linux, NGINX, MariaDB, PHP/WordPress) entirely via Docker Compose.

**Design Choices & Architecture:**
The infrastructure is built using separate, dedicated containers for each service, adhering to the microservices philosophy (one process per container). The stack utilizes Alpine/Debian Linux as the base image. Services communicate over a secure, isolated Docker bridge network, meaning MariaDB and WordPress are entirely shielded from the host network, with only NGINX exposing port 443 (HTTPS) to the outside world.

### Technical Comparisons
* **Virtual Machines vs Docker:** Virtual Machines virtualize the entire hardware layer, requiring a full guest Operating System for every instance, which consumes significant RAM and CPU. Docker (containers) virtualizes only the OS level, sharing the host's kernel. This makes containers incredibly lightweight, fast to boot, and highly portable.
* **Secrets vs Environment Variables:** Environment variables are often used to pass configuration data into containers at runtime, but they can be exposed in logs or via `docker inspect`. Docker Secrets provide a more secure mechanism (often used in Docker Swarm) by mounting encrypted data directly into the container's temporary memory file system, ensuring passwords are never stored in plain text on the disk.
* **Docker Network vs Host Network:** Using the host network removes network isolation, tying the container directly to the host's IP and ports. This project uses a custom Docker bridge network (`inception`), which creates an isolated LAN for the containers. This provides security (databases aren't exposed to the host) and automatic internal DNS resolution (WordPress can ping MariaDB by its container name).
* **Docker Volumes vs Bind Mounts:** Bind mounts map a specific file or directory on the host machine directly into the container, depending heavily on the host's specific directory structure. Docker Volumes are managed natively by Docker within its own storage directory, making them easier to back up, migrate, and manage across different operating systems. This project utilizes a hybrid approach: local volumes with bind options to securely store database and web files in `/home/ilarhrib/data/`.

## Instructions
To compile, install, and execute the project, use the provided `Makefile` at the root of the repository.

1. Ensure your host machine's `/etc/hosts` file resolves `ilarhrib.42.fr` to `127.0.0.1`.
2. Ensure the data directories exist on your host machine: `/home/ilarhrib/data/wordpress` and `/home/ilarhrib/data/mariadb`.
3. Create a `.env` file at the root of the `srcs` directory with the necessary database and WordPress credentials.
4. Run `make` or `make all` to build the images and deploy the containers in the background.
5. Access the site via `https://ilarhrib.42.fr`.
6. To stop the project, run `make down`. To completely wipe the project (including volumes and images), run `make fclean`.

## Resources
* [Docker Official Documentation](https://docs.docker.com/)
* [NGINX Reverse Proxy Configuration](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
* [WP-CLI Documentation for Automated Installs](https://developer.wordpress.org/cli/commands/)
* [MariaDB Server Configuration](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/)

**AI Usage Statement:**
AI was utilized during the development of this project as an interactive debugging and architectural sounding board. Specifically, AI was used to:
- Troubleshoot internal Docker networking issues (resolving `1130 Host is not allowed to connect` errors by adjusting MariaDB wildcard permissions).