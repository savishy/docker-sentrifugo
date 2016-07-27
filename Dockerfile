FROM ubuntu:16.04
RUN apt-get update

# install needed packages
RUN apt-get install -y software-properties-common debconf-utils nginx supervisor unzip

# install mysql and configure it headlessly
RUN apt-get update \
    && echo mysql-server-5.7 mysql-server/root_password password example_password | debconf-set-selections \
    && echo mysql-server-5.7 mysql-server/root_password_again password example_password | debconf-set-selections \
    && apt-get install -y mysql-server-5.7 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && apt-get install -y net-tools --fix-missing \
    && rm -rf /var/lib/apt/lists/* 

# add php 7 ppa
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
# install php
# TODO "There were unauthenticated packages and -y was used without --allow-unauthenticated"

RUN apt-get install -y php7.0 php7.0-fpm php7.0-mysql php7.0-gd --allow-unauthenticated

# create directories
RUN mkdir -p /var/log/supervisor /run/php/ /etc/nginx /var/log/sentrifugo

# fix for issue #1
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/sites-available/sentrifugo /etc/nginx/sites-available/sentrifugo
RUN rm /etc/nginx/sites-enabled/default
#ADD nginx/sites-available/default /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/sentrifugo /etc/nginx/sites-enabled/sentrifugo
#RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# expose port 80 for nginx
EXPOSE 80

# configure php
ADD php-fpm/php.ini /etc/php/7.0/fpm/php.ini
ADD php-fpm/sentrifugo.conf /etc/php/7.0/fpm/pool.d/sentrifugo.conf
ADD php-fpm/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

# configure supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# extract and add sentrifugo zip
ADD Sentrifugo-2.1.1.zip /sentrifugo.zip
RUN unzip /sentrifugo.zip -d / && rm -rfv /sentrifugo.zip && mv -v /Sentrifugo_2.1.1 /sentrifugo
RUN chown -R www-data:www-data /sentrifugo/


CMD ["/usr/bin/supervisord"]
