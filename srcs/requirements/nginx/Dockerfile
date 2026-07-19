# pulling the debian 11 os inside the container
FROM debian:bullseye

# installing the nginx webserver and the encryption tool to genereate a certificate
RUN apt-get update -y && apt-get install -y nginx openssl

# creating the dir where the certificate and key will live
RUN mkdir -p /etc/nginx/ssl

#creating the cert and the key and config the subj
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=MA/ST=BeniMellal/L=Khouribga/O=42/OU=1337/CN=ilarhrib.42.fr/UID=ilarhrib"

# putting our config file in the container
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# runing our webserver as PID 1 and making it glued to the terminal so the container remain on
CMD ["nginx", "-g", "daemon off;"]