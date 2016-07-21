FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y nginx
RUN service ufw start
RUN ufw allow 'Nginx HTTP'
RUN apt-get install mysql-server
RUN apt-get install php-fpm php-mysql

