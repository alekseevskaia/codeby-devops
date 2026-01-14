#!/bin/bash
set -e

DOMAIN="myname.local"
WWW_DOMAIN="www.$DOMAIN"
CERT_DIR="/etc/ssl/mycert"
APACHE_SITE="/etc/apache2/sites-available/${DOMAIN}.conf"
apt update
apt install -y apache2 ssl-cert
a2enmod ssl
a2enmod rewrite

mkdir -p "$CERT_DIR"
openssl req -x509 -nodes -days 3650 \
  -newkey rsa:2048 \
  -keyout "$CERT_DIR/$DOMAIN.key" \
  -out "$CERT_DIR/$DOMAIN.crt" \
  -subj "/C=RU/ST=Moscow/L=Moscow/O=MyOrg/CN=$DOMAIN"

chmod 600 "$CERT_DIR/$DOMAIN.key"
chmod 644 "$CERT_DIR/$DOMAIN.crt"

cat > "$APACHE_SITE" <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias $WWW_DOMAIN
    Redirect permanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    ServerAlias $WWW_DOMAIN
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile $CERT_DIR/$DOMAIN.crt
    SSLCertificateKeyFile $CERT_DIR/$DOMAIN.key

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^$WWW_DOMAIN$ [NC]
    RewriteRule ^(.*)$ https://$DOMAIN/$1 [R=301,L]
</VirtualHost>
EOF

a2ensite "$DOMAIN"
a2dissite 000-default
systemctl restart apache2