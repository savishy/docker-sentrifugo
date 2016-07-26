FROM nginx:latest

RUN apt-get update && apt-get install -y unzip

# create directories
RUN mkdir -p /var/log/supervisor /run/php/ /etc/nginx/sites-enabled /etc/nginx/sites-available

# extract and add sentrifugo zip
ADD Sentrifugo-2.1.1.zip /sentrifugo.zip
RUN unzip /sentrifugo.zip -d / && rm -rfv /sentrifugo.zip && mv -v /Sentrifugo_2.1.1 /usr/share/nginx/html/localhost


# nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/sites-available/sentrifugo /etc/nginx/sites-available/localhost
# RUN unlink /etc/nginx/sites-enabled/default
# ADD nginx/sites-available/default /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
# RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 80
