#!/bin/bash
set -e

SERVER_IP="192.168.56.10"
DOMAIN="myname.local"
WWW_DOMAIN="www.$DOMAIN"
CERT_PATH="/vagrant/lesson8/server-cert.crt"

grep -q "$DOMAIN" /etc/hosts || echo "$SERVER_IP $DOMAIN $WWW_DOMAIN" >> /etc/hosts
CERT_DIR="/usr/local/share/ca-certificates/mycert"
mkdir -p "$CERT_DIR"
openssl req -x509 -nodes -days 3650 \
  -newkey rsa:2048 \
  -keyout /tmp/dummy.key \
  -out "$CERT_DIR/myname.local.crt" \
  -subj "/C=RU/ST=Moscow/L=Moscow/O=MyOrg/CN=myname.local"

update-ca-certificates