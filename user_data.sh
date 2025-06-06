#!/bin/bash
# Install necessary packages
yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd mariadb-server

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Install WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress latest.tar.gz
chmod -R 755 /var/www/html/
chown -R apache:apache /var/www/html/

# Configure WordPress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/${db_name}/g" /var/www/html/wp-config.php
sed -i "s/username_here/${db_user}/g" /var/www/html/wp-config.php
sed -i "s/password_here/${db_password}/g" /var/www/html/wp-config.php
sed -i "s/localhost/${db_host}/g" /var/www/html/wp-config.php

# Generate WordPress salts
SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sed -i "/AUTH_KEY/d" /var/www/html/wp-config.php
sed -i "/SECURE_AUTH_KEY/d" /var/www/html/wp-config.php
sed -i "/LOGGED_IN_KEY/d" /var/www/html/wp-config.php
sed -i "/NONCE_KEY/d" /var/www/html/wp-config.php
sed -i "/AUTH_SALT/d" /var/www/html/wp-config.php
sed -i "/SECURE_AUTH_SALT/d" /var/www/html/wp-config.php
sed -i "/LOGGED_IN_SALT/d" /var/www/html/wp-config.php
sed -i "/NONCE_SALT/d" /var/www/html/wp-config.php
sed -i "/#@-/a $SALTS" /var/www/html/wp-config.php

# Restart Apache
systemctl restart httpd