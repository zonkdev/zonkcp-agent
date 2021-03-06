#!/usr/bin/env bash

while getopts d:s:u: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
        s) siteDir=${OPTARG};;
        u) username=${OPTARG};;
    esac
done

# Variables
VHOST_DIR='./docker/nginx/vhost'
SITE_DIR='./sites'
DOMAIN=$domain

# Functions
log() { echo $1; }
error() { echo $1; exit 1; }

if [[ $DOMAIN == '' ]]
then
 error 'Domain is required'
fi

# Create nginx config file
log 'Create nginx configuration'
cat > $VHOST_DIR/$DOMAIN-vhost.conf <<EOF
server {
    listen       80;
    listen  [::]:80;
    server_name  $DOMAIN;

    location / {
        root   /var/www/html/$DOMAIN;
        index  index.html;
    }

    # redirect not found pages to the static page /404.html
    #
    error_page  404              /404.html;
    location = /404.html {
        root   /var/www/html/default;
    }

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /var/www/html/default;
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

# Creating webroot directory
log 'Create webroot directory'
mkdir -p $SITE_DIR/$DOMAIN

# Creating index.html file
log 'Create index.html file'
cat > $SITE_DIR/$DOMAIN/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <title>Site is ready</title>

    <style id="" media="all">
      /* thai */
      @font-face {
        font-family: "Kanit";
        font-style: normal;
        font-weight: 200;
        src: url(//fonts.gstatic.com/s/kanit/v7/nKKU-Go6G5tXcr5aOhWzVaFrNlJzIu4.woff2)
          format("woff2");
        unicode-range: U+0E01-0E5B, U+200C-200D, U+25CC;
      }
      /* vietnamese */
      @font-face {
        font-family: "Kanit";
        font-style: normal;
        font-weight: 200;
        src: url(//fonts.gstatic.com/s/kanit/v7/nKKU-Go6G5tXcr5aOhWoVaFrNlJzIu4.woff2)
          format("woff2");
        unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169,
          U+01A0-01A1, U+01AF-01B0, U+1EA0-1EF9, U+20AB;
      }
      /* latin-ext */
      @font-face {
        font-family: "Kanit";
        font-style: normal;
        font-weight: 200;
        src: url(//fonts.gstatic.com/s/kanit/v7/nKKU-Go6G5tXcr5aOhWpVaFrNlJzIu4.woff2)
          format("woff2");
        unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB,
          U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
      }
      /* latin */
      @font-face {
        font-family: "Kanit";
        font-style: normal;
        font-weight: 200;
        src: url(//fonts.gstatic.com/s/kanit/v7/nKKU-Go6G5tXcr5aOhWnVaFrNlJz.woff2)
          format("woff2");
        unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6,
          U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193,
          U+2212, U+2215, U+FEFF, U+FFFD;
      }
    </style>
    <style>
      * {
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
      }

      body {
        padding: 0;
        margin: 0;
      }

      #maintenance {
        position: relative;
        height: 100vh;
      }

      #maintenance .maintenance {
        position: absolute;
        left: 50%;
        top: 50%;
        -webkit-transform: translate(-50%, -50%);
        -ms-transform: translate(-50%, -50%);
        transform: translate(-50%, -50%);
      }

      .maintenance {
        max-width: 500px;
        width: 100%;
        line-height: 1.4;
        /* text-align: center; */
        padding: 15px;
      }

      .maintenance h2 {
        font-family: "Kanit", sans-serif;
        font-size: 33px;
        font-weight: bold;
        margin-top: 0px;
        margin-bottom: 25px;
        letter-spacing: 3px;
      }

      .maintenance p {
        font-family: "Kanit", sans-serif;
        font-size: 16px;
        font-weight: 200;
        margin-top: 0px;
        margin-bottom: 25px;
      }

      .maintenance a {
        font-family: "Kanit", sans-serif;
        color: #ff6f68;
        font-weight: 200;
        text-decoration: none;
        border-bottom: 1px dashed #ff6f68;
        border-radius: 2px;
      }

      @media only screen and (max-width: 480px) {
        .maintenance h2 {
          font-size: 22px;
        }
      }
    </style>

    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <meta name="robots" content="noindex, follow" />
  </head>
  <body>
    <div id="maintenance">
      <div class="maintenance">
        <h2>Your site is ready!</h2>
        <p id="qoute-content"></p>
        <p id="qoute-author"></p>
      </div>
    </div>
  </body>
  <script
    src="https://code.jquery.com/jquery-3.6.0.min.js"
    integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
    crossorigin="anonymous"
  ></script>
  <script>
    jQuery.ajax({
      type: 'GET',
      url: 'https://api.quotable.io/random',
      data: {
        // tags: 'technology,famous-quotes',
      },
      async: false,
      success: (data) => {
        jQuery('p#qoute-content').html(data.content);
        jQuery('p#qoute-author').html('- ' + data.author);
      },
    });
  </script>
</html>
EOF

# Restart Nginx
log 'Restart nginx'
docker exec -it nginx nginx -s reload

log "Site created for $DOMAIN"