# pulling a debian 11 filesystem
FROM debian:bullseye 

# core php processing engine and communication tools required for the inter-communication bettween wordpress and database
RUN apt-get update -y && apt-get install -y \ 
	php7.4 \
	php-fpm \
	php-mysql \
	mariadb-client \
	curl 

# installing the wordpress command line interface and move it to bin so it becomes a globale runnable
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# injecting our custom files conf andd the script into the container space
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000 

# setting our root directory so nginx can read all the files it need 
WORKDIR /var/www/wordpress

#runing our script the moment the container is runing 
CMD ["/usr/local/bin/script.sh"]