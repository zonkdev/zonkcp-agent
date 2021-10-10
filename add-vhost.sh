#!/usr/bin/env bash

read -p "Enter domain name : " domain

# Variables
NGINX_ENABLED_VHOSTS='./docker/nginx/vhost'
WEB_DIR='./sites'
WEB_USER="zonkdev"
WEB_DOMAIN=$domain

# Functions
ok() { echo -e '\e[32m'$WEB_DOMAIN'\e[m'; } # Green
die() { echo -e '\e[1;31m'$WEB_DOMAIN'\e[m'; exit 1; }

# Create nginx config file
cat > $NGINX_ENABLED_VHOSTS/$WEB_DOMAIN-vhost.conf <<EOF
server {
    listen       80;
    listen  [::]:80;
    server_name  $WEB_DOMAIN;

    location / {
        root   /var/www/html/$WEB_DOMAIN;
        index  index.html;
    }

    # redirect not found pages to the static page /404.html
    #
    error_page  404              /404.html;
    location = /404.html {
        root   /var/www/html/;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /var/www/html/;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }

    # Enable client-side caching for images
    #
    location ~* \.(jpg|jpeg|png|gif|ico)$ {
       expires 30d;
    }

    # Enable client-side caching for css, js, pdf
    #
    location ~* \.(css|js|pdf)$ {
       expires 7d;
    }
}
EOF

# Creating webroot directories
mkdir -p $WEB_DIR/$WEB_DOMAIN

# Creating index.html file
cat > $WEB_DIR/$WEB_DOMAIN/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Site is ready</title>
  </head>
  <body>
    <code>$WEB_DOMAIN is ready</code>
  </body>
</html>
EOF

# Restart Nginx
docker exec -it nginx nginx -s reload

ok "Site Created for $domain"