# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vismaily <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/28 20:11:02 by vismaily          #+#    #+#              #
#    Updated: 2021/05/04 21:46:08 by vismaily         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y nginx
RUN apt-get install -y mariadb-server
RUN apt-get install -y php7.3 php-fpm php-mysql php-gd php-pdo php-cli php-mbstring php-zip php-xmlrpc php-xml php-soap 
RUN apt-get install -y vim

WORKDIR /etc/nginx/sites-available/

COPY ./srcs/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled
RUN rm /etc/nginx/sites-enabled/default

WORKDIR /var/www/server

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /var/www/server/wordpress

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.4-all-languages phpmyadmin
COPY ./srcs/my-admin.php /var/www/server/phpmyadmin

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=AM/ST=Yerevan/L=Yerevan/O=42 School/OU=vismaily/CN=localhost"

COPY ./srcs/setup.sh ./wordpress

CMD bash ./wordpress/setup.sh
