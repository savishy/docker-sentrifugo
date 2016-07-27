FROM nginx:latest

RUN apt-get update

# nginx image uses debian jessie 
RUN apt-get install -y unzip php5-fpm php5-mysql

# create directories
RUN mkdir -p /var/log/supervisor /run/php/ /etc/nginx/sites-enabled /etc/nginx/sites-available

# extract and add sentrifugo zip
ADD Sentrifugo-2.1.1.zip /sentrifugo.zip
RUN unzip /sentrifugo.zip -d / && rm -rfv /sentrifugo.zip && mv -v /Sentrifugo_2.1.1 /usr/share/nginx/html/sentrifugo

# php-fpm setup
ADD php-fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD php-fpm/php.ini /etc/php5/fpm/php.ini
ADD php-fpm/sentrifugo.conf /etc/php5/fpm/pool.d/sentrifugo.conf

# nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/sites-available/sentrifugo /etc/nginx/sites-available/sentrifugo
# RUN unlink /etc/nginx/sites-enabled/default
# ADD nginx/sites-available/default /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/sentrifugo /etc/nginx/sites-enabled/sentrifugo
# RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 80
