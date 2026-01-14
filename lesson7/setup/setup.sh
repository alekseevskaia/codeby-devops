apt install -y apache2
a2dissite 000-default
apachectl graceful
mkdir -p /opt/apache/www
cp /vagrant/test.html /opt/apache/www
cp /vagrant/apache_config.conf /etc/apache2/sites-available/
a2ensite apache_config
apt install -y nginx
rm /etc/nginx/sites-enabled/default
mkdir -p /opt/nginx/www 
cp /vagrant/test.html /opt/nginx/www
cp /vagrant/nginx_config.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx_config.conf /etc/nginx/sites-enabled/nginx_config.conf
nginx -s reload -t