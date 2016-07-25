FROM ubuntu:16.04
RUN apt-get update

# fix for issue #1
RUN apt-get install -y debconf-utils
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# nginx
RUN apt-get install -y nginx
COPY nginx.conf /etc/nginx/nginx.conf
# expose port 80 for nginx
EXPOSE 80

# install mysql and configure it headlessly
RUN apt-get update \
    && echo mysql-server-5.7 mysql-server/root_password password example_password | debconf-set-selections \
    && echo mysql-server-5.7 mysql-server/root_password_again password example_password | debconf-set-selections \
    && apt-get install -y mysql-server-5.7 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && apt-get install -y net-tools --fix-missing \
    && rm -rf /var/lib/apt/lists/* 

# install php and supervisor

RUN apt-get update && apt-get install -y php-fpm php-mysql supervisor
RUN mkdir -p /var/log/supervisor /run/php/ /etc/nginx
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# extract and add sentrifugo zip
ADD Sentrifugo-2.1.1.zip /sentrifugo/


CMD ["/usr/bin/supervisord"]
