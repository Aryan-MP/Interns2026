#!/bin/bash
sudo apt update -y
sudo apt install nginx -y

sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;

    location / {
        proxy_pass http://10.0.2.4;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

sudo systemctl restart nginx
