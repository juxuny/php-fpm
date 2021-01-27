FROM ubuntu:18.04
RUN apt-get update && apt-get install -y software-properties-common language-pack-en-base
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN echo "LANG=en_US.utf-8" >> /etc/environment
RUN echo "LC_ALL=en_US.utf-8" >> /etc/environment
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" >> /etc/apt/sources.list.d/php-7.3.list
RUN echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" >> /etc/apt/sources.list.d/php-7.3.list
RUN echo "\n" | add-apt-repository  ppa:ondrej/nginx && echo "\n" | add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -y php7.3
RUN apt-get install -y php7.3-cli php7.3-fpm php7.3-json php7.3-pdo php7.3-mysql php7.3-zip php7.3-gd  php7.3-mbstring php7.3-curl php7.3-xml php7.3-bcmath php7.3-json php7.3-redis
RUN sed -i -e 's/\/run\/php\/php7.3-fpm.sock/0.0.0.0:9000/g' /etc/php/7.3/fpm/pool.d/www.conf
RUN mkdir -p /run/php
RUN apt-get install -y libmosquitto-dev php-pear libcurl3-openssl-dev php7.3-dev
RUN pecl install Mosquitto-alpha && echo "extension=mosquitto.so" >> /etc/php/7.3/fpm/conf.d/php-mosquitto.ini
EXPOSE 9000
ENTRYPOINT php-fpm7.3 -c /etc/php/7.3/fpm/php-fpm.conf -F
