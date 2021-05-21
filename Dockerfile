FROM debian:buster

#https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mariadb-php-lemp-stack-on-debian-10
#clear cash https://habr.com/ru/company/ruvds/blog/440658/

RUN apt-get update && apt-get install -y \
    #allows to download from terminal
    wget \
    nginx \
    mariadb-server \
    php-fpm \
    php-mysql \
    php-mbstring \
    php-xml \
    php-curl \
    php-gd \
    vim

RUN rm -rf /etc/nginx/sites-available/default 
RUN rm -rf /etc/nginx/sites-enabled/default

WORKDIR /var/www/html

#nginx https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04

COPY srcs/nginx.conf /etc/nginx/sites-available/mybobo
RUN ln -s /etc/nginx/sites-available/mybobo /etc/nginx/sites-enabled/mybobo


#for WordPresss https://www.rosehosting.com/blog/how-to-install-wordpress-with-nginx-on-debian-10/

RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvzf latest.tar.gz \
    && rm -rf latest.tar.gz
COPY srcs/wp-config.php wordpress


#phpMyAdmin

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz \
    && tar -xvzf phpMyAdmin-5.1.0-english.tar.gz \
    && rm -rf phpMyAdmin-5.1.0-english.tar.gz
    

#SSL https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
#-subj - so the information will be filled while running (link below)
# https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/nginx.key -out /etc/ssl/nginx.crt -subj "/C=LV/ST=Riga Region/L=Riga/O=Bobo/OU=IT/CN=agidget"

# Giving nginx's user-group rights over page files
RUN	chown -R www-data:www-data /var/www/html/*

# Ports that needs to be exposed at run time with -p [host port]:[container port]
EXPOSE 80 443

COPY srcs/runme.sh ./
CMD bash runme.sh