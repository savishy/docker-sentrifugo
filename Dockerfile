FROM ubuntu:16.04
RUN apt-get update

# install needed packages
RUN apt-get install -y debconf-utils nginx php-fpm php-mysql supervisor unzip

# create directories
RUN mkdir -p /var/log/supervisor /run/php/ /etc/nginx

# fix for issue #1
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/sites-available/sentrifugo /etc/nginx/sites-available/sentrifugo
RUN unlink /etc/nginx/sites-enabled/default
ADD nginx/sites-available/default /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/sentrifugo /etc/nginx/sites-enabled/sentrifugo
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# test
ADD index.nginx-debian.html /var/www/html/index.nginx-debian.html

# expose port 80 for nginx
EXPOSE 80

# install mysql and configure it headlessly
RUN apt-get update \
    && echo mysql-server-5.7 mysql-server/root_password password example_password | debconf-set-selections \
    && echo mysql-server-5.7 mysql-server/root_password_again password example_password | debconf-set-selections \
    && apt-get install -y mysql-server-5.7 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && apt-get install -y net-tools --fix-missing \
    && rm -rf /var/lib/apt/lists/* 

# configure php
ADD php-fpm/php.ini /etc/php/7.0/fpm/php.ini

# configure supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# extract and add sentrifugo zip
ADD Sentrifugo-2.1.1.zip /sentrifugo.zip
RUN unzip /sentrifugo.zip -d / && rm -rfv /sentrifugo.zip && mv -v /Sentrifugo_2.1.1 /sentrifugo

CMD ["/usr/bin/supervisord"]
