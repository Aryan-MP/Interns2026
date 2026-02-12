#!/bin/bash

# Update system packages
sudo apt-get update -y

# Install Nginx
sudo apt-get install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Create a beautiful index.html page
cat <<EOF | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Fardeen's WebApp</title>
    <style>
        body {
            background: linear-gradient(to right, #00c6ff, #0072ff);
            color: #fff;
            font-family: 'Arial', sans-serif;
            text-align: center;
            padding-top: 100px;
        }
        h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.5em;
        }
        .footer {
            margin-top: 50px;
            font-size: 1em;
            opacity: 0.7;
        }
    </style>
</head>
<body>
    <h1>Welcome to Fardeen's WebApp!</h1>
    <p>This page is deployed via ARM template and Nginx.</p>
    <div class="footer">🚀 Enjoy your automated deployment!</div>
</body>
</html>
EOF

# Adjust permissions
sudo chmod 644 /var/www/html/index.html

# Reload Nginx to apply changes
sudo systemctl reload nginx
