# Day 7 - Assignment

## Task - 1 Ubuntu VM, Docker Setup & Nginx Container Deployment

### Deploy an Ubuntu Virtual Machine, install Docker, pull and run an Nginx container, and verify web accessibility through a browser.

### 1. Ubuntu Virtual Machine Deployment
Deployed an Ubuntu-based Virtual Machine
Configured networking (Public IP + NSG rules)
Enabled SSH access
Verified successful remote login

### 2. Docker Installation
Updated package repositories
Installed Docker Engine
Enabled and started Docker service
Verified installation using:
docker --version
Test container execution
Concepts Applied
Container runtime installation
Linux package management
Service management

### 3. Nginx Image Deployment
Pulled official Nginx image from Docker Hub
Created and ran container using:
Port mapping (e.g., 80:80)
Ensured container status was running
Concepts Applied
Docker image vs container
Port binding
Container lifecycle management

### 4. Validation
Accessed VM Public IP in browser
Verified Nginx default landing page
Confirmed containerized web server deployment
