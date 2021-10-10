FROM php:7.4-fpm-alpine

RUN apk update && apk add supervisor zip libzip-dev libpng-dev jpeg-dev

RUN docker-php-ext-configure gd --with-jpeg

RUN docker-php-ext-install pdo_mysql bcmath zip sockets -j$(nproc) gd

RUN addgroup -g 1000 zonkdev && adduser -G zonkdev -g zonkdev -s /bin/sh -D zonkdev

RUN mkdir -p /var/log/supervisord

RUN mkdir -p /usr/share/nginx/html

RUN chown -R zonkdev:zonkdev /usr/share/nginx/html

ADD ./docker/php/conf/www.conf /usr/local/etc/php-fpm.d/www.conf

ADD ./docker/php/conf/php-override.ini /usr/local/etc/php/conf.d/php-override.ini

ADD ./docker/supervisord/conf/supervisord.conf /etc/supervisord.conf

ADD ./docker/supervisord/conf/php-fpm.ini /etc/supervisor.d/php-fpm.ini

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

WORKDIR /usr/share/nginx/html