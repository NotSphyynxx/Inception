# pulling an empty debian 11 filesystem
FROM debian:bullseye 

# updating the local list of softwares and install the mariadbserver binnaries which manage the sql table and listen on port 3306
RUN apt-get update -y && apt-get install -y mariadb-server

# using our 50-server.cnf file rather than the default brought by mariadb so we can customize the bind-adress since it comes with only listeing to itself 127.0.0.1 and we will configure that in our file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
#putting our database formatting script in the standard dir in the linux $PATH so it gets run later as a globaly runable program
COPY ./tools/script.sh /usr/local/bin/script.sh 
RUN chmod +x /usr/local/bin/script.sh
#when the container is on we run this script to create the users, format the tables, and lock the container and it will be the PID 1
CMD ["/usr/local/bin/script.sh"]