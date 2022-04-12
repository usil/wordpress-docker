FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

# set shell options (see documentation for more details)
RUN set -eux

RUN apt-get update
RUN apt-get install -y software-properties-common curl
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update -y

RUN apt-get install -y apache2 sendmail
RUN apt-get install -y php7.4 libapache2-mod-php7.4 php7.4-cli php7.4-common php7.4-mbstring php7.4-gd php7.4-intl php7.4-xml php7.4-mysql php7.4-mcrypt php7.4-zip

RUN php -v

# enable Apache2 rewrite module
RUN a2enmod rewrite

## copy custom wordpress code

RUN mkdir -p /var/www/html
# comment for development purpose
COPY . /var/www/html


# install wp cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

## configure apache

# remove ubuntu apache default page
RUN rm /var/www/html/index.html

ENV CUSTOM_DOCUMENT_ROOT=\/var\/www\/html

# fix warning
# AH00558: apache2: Could not reliably determine the server's fully qualified domain name,
# using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN echo "<Directory $CUSTOM_DOCUMENT_ROOT>" >> /etc/apache2/apache2.conf
RUN echo "    Options Indexes FollowSymLinks" >> /etc/apache2/apache2.conf
RUN echo "    AllowOverride All" >> /etc/apache2/apache2.conf
RUN echo "    Require all granted" >> /etc/apache2/apache2.conf
RUN echo "</Directory>" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# final docker configuration

COPY DockerfileEntryPoint.sh /usr/local/bin/DockerfileEntryPoint.sh
RUN chmod 744 /usr/local/bin/DockerfileEntryPoint.sh

ENTRYPOINT ["DockerfileEntryPoint.sh"]
