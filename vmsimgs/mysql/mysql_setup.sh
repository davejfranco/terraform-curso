#!/bin/bash

#Change mysql default root password
MYSQLPASS=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $13}')
NEWPASS="&_gjpFd_0ul"
WPPASS="&_gjpFd_0um"
mysql -u root -p"$MYSQLPASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEWPASS';"

cat << EOF > /tmp/wp_setup.sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'%' IDENTIFIED BY '$WPPASS';
GRANT ALL ON wordpress.* TO 'wordpressuser'@'%';
EOF

#Setup wordpress DB
mysql -u root -p"$NEWPASS" < /tmp/wp_setup.sql

