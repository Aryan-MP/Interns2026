#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
echo "<h1>Private Backend Web Server</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart nginx
