# Day 7 – Assessment & Solution  
## Docker, Containers & Azure Container Registry

---

## Assessment Objective
To deploy a web application using Docker, package it as a container image, store it securely in Azure Container Registry, and verify successful deployment.

---

## Task 1: Create Ubuntu Virtual Machine

### What it is
Creating a Linux Virtual Machine to act as the Docker host.

### Why it is done
- Docker requires a host machine
- VM provides compute, OS, and network
- Used as build and run environment

### How it is done
- Created an Ubuntu Linux VM
- VM was prepared for Docker installation

---

## Task 2: Install Docker on VM

### What it is
Installing Docker engine on the Virtual Machine.

### Why it is done
- Docker is required to build and run containers
- Without Docker, containers cannot be created

### How it is done
- Installed Docker using package manager
- Verified Docker installation
- Ensured Docker service was running

---

## Task 3: Create Custom HTML Website

### What it is
Creating a simple static web application.

### Why it is done
- To have content for containerized application
- HTML file represents the application

### How it is done
- Created index.html
- Added custom web content

---

## Task 4: Create Dockerfile

### What it is
A Dockerfile defines how the Docker image is built.

### Why it is done
- Required to package the application into an image
- Ensures consistent builds

### How it is done
- Used nginx as base image
- Copied index.html into nginx directory
- Configured container to serve website on port 80

---

## Task 5: Build Docker Image

### What it is
Creating a Docker image from the Dockerfile.

### Why it is done
- Image is portable and reusable
- Used to create containers

### How it is done
- Ran Docker build command
- Image was created and stored locally on VM

---

## Task 6: Test Application Locally

### What it is
Running the Docker image as a container.

### Why it is done
- To verify application works before pushing to registry
- Ensures correct configuration

### How it is done
- Ran container from image
- Accessed website using VM public IP and port 80
- Verified website loaded successfully

---

## Task 7: Create Azure Container Registry (ACR)

### What it is
Creating a private container registry in Azure.

### Why it is done
- To store Docker images securely
- Used instead of public registries for production

### How it is done
- Created Azure Container Registry
- Used ACR as image repository

---

## Task 8: Authenticate to ACR

### What it is
Logging in to Azure Container Registry from Docker.

### Why it is done
- Authentication is required to push images
- Prevents unauthorized access

### How it is done
- Enabled admin user (training purpose)
- Logged in to ACR using Docker login

---

## Task 9: Tag Docker Image for ACR

### What it is
Renaming the Docker image to match ACR format.

### Why it is done
- Required before pushing image to ACR
- Includes registry name, repository, and tag

### How it is done
- Tagged image using ACR login server name

---

## Task 10: Push Image to ACR

### What it is
Uploading Docker image to Azure Container Registry.

### Why it is done
- To store image in Azure
- To make image available for deployment

### How it is done
- Pushed Docker image to ACR
- Upload completed successfully

---

## Task 11: Verify Image in ACR

### What it is
Confirming that the image exists in Azure Container Registry.

### Why it is done
- To ensure image push was successful
- To validate ACR configuration

### How it is done
- Checked ACR repositories
- Verified image name and tag

---

## Assessment Outcome
- Ubuntu VM created as Docker host
- Docker installed and verified
- Web application containerized successfully
- Docker image built and tested
- Azure Container Registry created
- Image pushed and verified in ACR
- Understood Docker and Azure container workflow
