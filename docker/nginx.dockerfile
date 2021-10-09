FROM nginx:stable-alpine

RUN addgroup -g 1000 zonkdev && adduser -G zonkdev -g zonkdev -s /bin/sh -D zonkdev

RUN mkdir -p /var/www/html

RUN chown zonkdev:zonkdev /var/www/html

ADD ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
