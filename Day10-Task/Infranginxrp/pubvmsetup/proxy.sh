#!/bin/bash

# Exit if any command fails
set -e

echo "Updating system..."
sudo apt update -y

echo "Installing Nginx..."
sudo apt install nginx -y

echo "Removing default Nginx site..."
sudo rm -f /etc/nginx/sites-enabled/default

echo "Creating reverse proxy configuration..."

sudo tee /etc/nginx/sites-available/reverse-proxy <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://10.0.2.4;
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

echo "Enabling reverse proxy site..."
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/

echo "Testing Nginx configuration..."
sudo nginx -t

echo "Restarting Nginx..."
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "Reverse proxy setup completed successfully!"
