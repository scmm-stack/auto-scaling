#!/bin/bash
apt update
apt -y install apache2
apt -y install php libapache2-mod-php
systemctl restart apache2
ufw allow 'Apache'
touch /var/www/html/health_check
