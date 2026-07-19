# pulling a debian 11 filesystem
FROM debian:bullseye 

RUN apt-get update -y && apt-get install -y \
	php7.4 \
	php-fpm \
	php-mysql \
	mariadb-client \
	curl 

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/script.sh /usr/local/bin/script.sh

WORKDIR /var/www/wordpress

CMD ["/usr/local/bin/script.sh"]