Task 01: Azure VM Creation with Docker and NGINX Installation
Description

In this task, I created an Azure Virtual Machine and installed Docker on it. Using Docker, I pulled and ran an NGINX Docker image to set up a basic web server. This validates containerized application deployment on an Azure VM.

Steps Performed

Created an Azure Virtual Machine

Installed Docker Engine on the VM

Pulled the official NGINX Docker image from Docker Hub

Ran the NGINX container using Docker

Verified NGINX service by accessing the VM’s public IP address
<img width="1920" height="1080" alt="Screenshot (143)" src="https://github.com/user-attachments/assets/56f94226-c349-4e2a-a9c0-c833f5784bbe" />


Outcome

Azure VM successfully created

Docker installed and running

NGINX web server deployed using Docker container




Task 02: Custom Content Deployment on NGINX
Description

In this task, I customized the default NGINX web page by adding custom content. The changes were deployed inside the running Docker container, and the updated content was verified through the public IP address.

Steps Performed

Accessed the running NGINX Docker container

Modified the default NGINX HTML content

Added custom data content

Reloaded or restarted the NGINX container

Verified updated content through the browser using public IP
<img width="1920" height="1080" alt="Screenshot (142)" src="https://github.com/user-attachments/assets/1a791408-f29a-4038-a8be-c22c04b9c2ff" />


Outcome

Default NGINX page replaced with custom content

Successfully validated container-level content changes



Task 03: Docker Image Creation and Push to Docker Hub and Azure Container Registry (ACR) and Container Instances
Description

In this task, I created a custom Docker image using the modified NGINX configuration and pushed the image to Docker Hub. After that, the same image was pushed to Azure Container Registry (ACR) for enterprise-level container management.

Steps Performed

Created a Dockerfile for custom NGINX content

Built a custom Docker image locally

Tagged the image appropriately

Pushed the image to Docker Hub

Created an Azure Container Registry (ACR)

Logged in to ACR using Azure CLI

Tagged and pushed the Docker image to ACR
<img width="1920" height="1080" alt="Screenshot (144)" src="https://github.com/user-attachments/assets/4bfbaf8b-e59b-4850-8d4d-888faaca8582" />
<img width="1920" height="1080" alt="Screenshot (142)" src="https://github.com/user-attachments/assets/0b59a7f6-b710-4e18-b4c6-371bee7a1215" />


Outcome

Custom Docker image successfully created

Image pushed to Docker Hub

Image successfully pushed to Azure Container Registry

Enabled reuse of container image for Azure services
