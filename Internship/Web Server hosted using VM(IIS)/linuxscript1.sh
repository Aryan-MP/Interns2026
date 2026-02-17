#!/bin/bash
CUSTOM_HTML="$1"

# Update packages
apt-get update -y
apt-get install nginx -y

# Deploy HTML
echo "$CUSTOM_HTML" > /var/www/html/index.html

# Start NGINX
systemctl enable nginx
systemctl start nginx
