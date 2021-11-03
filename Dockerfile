FROM php:7.1-apache

MAINTAINER Roman Hofer

RUN mkdir /app
WORKDIR /app
RUN apt-get update && apt-get install -y  wget unzip libzip-dev zip libpng-dev libc-client-dev libkrb5-dev
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos
RUN docker-php-ext-install imap
RUN wget https://github.com/minthcm/minthcm/archive/refs/heads/master.zip -q
RUN unzip master.zip && rm -f master.zip

COPY apache/vhost.conf /etc/apache2/sites-available/000-default.conf

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -i "s|upload_max_filesize = 2M|upload_max_filesize = 50M|g" $PHP_INI_DIR/php.ini

RUN chown -R www-data:www-data /app && a2enmod rewrite
