# Azure Containerized NGINX Deployment

## Overview
This lab demonstrates a complete container workflow on Azure: building a custom NGINX image with Docker, persisting web content with volumes, pushing the image to Azure Container Registry (ACR), and deploying it through Azure Container Instances (ACI) for public access.

---

# Task 1 — Provision Ubuntu VM and Install Docker

- Created an Ubuntu virtual machine in Azure
- Connected via SSH
- Installed Docker engine
- Enabled and started Docker service
- Verified installation using `docker images`

**Result:** Container runtime ready on Azure VM

---

# Task 2 — Run NGINX Container with Port Mapping

- Pulled official NGINX image
- Ran container with port mapping:
  - Host port `8080` → container port `80`
- Opened port 8080 in NSG
- Verified access via VM public IP

**Result:** NGINX reachable through browser using VM IP and custom port

---

# Task 3 — Create Persistent Docker Volume

- Created named Docker volume
- Mounted volume to NGINX web root directory
- Added custom `index.html`
- Restarted container with volume mount
- Verified persistence after container recreation

**Result:** Static web content persisted independently of container lifecycle

---

# Task 4 — Build Custom NGINX Docker Image

- Created a dedicated working directory for the container build context
- Authored a custom `index.html` page with static web content
- Wrote a minimal Dockerfile based on the official NGINX base image
- Configured the Dockerfile to copy the custom HTML file into the NGINX web root
- Built a versioned Docker image locally using Docker build
- Verified successful image creation via local image listing

## Task 5 — Create Azure Container Registry (ACR)

- Provisioned an Azure Container Registry using the Azure Portal
- Selected Basic SKU for lightweight lab usage
- Enabled registry admin access for authenticated image push
- Retrieved registry login server and credentials

**Result:** Private Azure-hosted container registry ready to receive images

---

## Task 6 — Push Custom Image to ACR

- Authenticated Docker client against ACR
- Tagged the local image using ACR repository naming format
- Pushed the tagged image to the registry
- Verified repository and image tag presence in the Azure Portal

**Result:** Custom NGINX image stored securely in ACR

---

## Task 7 — Deploy Image via Azure Container Instances (ACI)

- Created a new Azure Container Instance using Portal workflow
- Selected Azure Container Registry as image source
- Chose the custom repository and version tag
- Configured public networking with exposed HTTP port
- Allocated standard compute resources
- Deployed the container instance

**Result:** Serverless container runtime successfully launched from private registry image

---

## Task 8 — Validate Public Endpoint

- Retrieved assigned public IP from container instance
- Accessed endpoint through browser
- Confirmed delivery of custom NGINX page

**Result:** Custom containerized web server publicly reachable

---

# Bash Command Script

1. **Create build directory and enter it:**
   ```bash
   mkdir nginx-custom
   cd nginx-custom
   ```

2. **Create a custom HTML file:**
   ```bash
   nano index.html
   ```

3. **Create a Dockerfile:**
   ```bash
   nano Dockerfile
   ```

4. **Build the Docker image:**
   ```bash
   sudo docker build -t nginx-custom:1.0 .
   ```

5. **Verify the image was created:**
   ```bash
   sudo docker images
   ```

6. **Login to Azure Container Registry (ACR):**
   ```bash
   sudo docker login <registry>.azurecr.io
   ```

7. **Tag the image for ACR:**
   ```bash
   sudo docker tag nginx-custom:1.0 <registry>.azurecr.io/nginx-custom:1.0
   ```

8. **Push the image to ACR:**
   ```bash
   sudo docker push <registry>.azurecr.io/nginx-custom:1.0
   ```
9/ **Pull into VM**
    ```bash
    docker pull <registry>.azurecr.io/<repo>:<tag>
    ```