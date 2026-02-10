# Day 7 – Docker, Containers & Azure Container Registry (ACR) & Azure Container Instance (ACI)

## Author
Manoj Gowda

---

## Assessment Objective
To build a containerized web application using Docker, store the image in Azure Container Registry, and run the container directly in Azure using Azure Container Instance without managing a Virtual Machine.

---

## Task 1: Create Ubuntu Virtual Machine (Docker Host)

### What it is
Creating a Linux Virtual Machine to install Docker and build container images.

### Why it is done
- Docker needs a host machine to build images
- VM provides OS, CPU, RAM, and network
- Used as build and testing environment

### How it is done
- Created an Ubuntu Linux Virtual Machine
- Used the VM to install and run Docker

---

## Task 2: Install Docker on Virtual Machine

### What it is
Installing Docker Engine on the VM.

### Why it is done
- Docker is required to build and run containers
- Without Docker, images cannot be created

### How it is done
- Installed Docker on Ubuntu
- Verified Docker installation using CLI
- Ensured Docker service was running

---

## Task 3: Create Web Application and Docker Image

### What it is
Packaging a web application into a Docker image.

### Why it is done
- Docker image contains application and dependencies
- Image is reusable and portable

### How it is done
- Created a simple HTML file (index.html)
- Created a Dockerfile using nginx as base image
- Built Docker image using Docker CLI

---

## Task 4: Push Docker Image to Docker Hub

### What it is
Uploading Docker image to Docker Hub (public registry).

### Why it is done
- Docker Hub allows sharing and testing images
- Helps understand public container registries

### How it is done
- Logged in to Docker Hub using Docker CLI
- Tagged the image correctly
- Pushed the image successfully

---

## Task 5: Create Azure Container Registry (ACR)

### What it is
Creating a private container registry in Azure.

### Why it is done
- To store images securely
- Recommended for production workloads
- Better control compared to public registries

### How it is done
- Created Azure Container Registry
- Used ACR as private image repository

---

## Task 6: Push Docker Image to Azure Container Registry (ACR)

### What it is
Uploading Docker image to Azure Container Registry.

### Why it is done
- To integrate Docker workflow with Azure
- To store images securely inside Azure

### How it is done
- Authenticated to ACR from the VM
- Tagged the image using ACR login server format
- Pushed the image to ACR successfully

---

## Task 7: Run Container Using Azure Container Instance (ACI)

### What it is
Running a container directly in Azure without using a Virtual Machine.

### Why it is done
- To avoid managing VMs and OS
- To run containers in the simplest way
- To reduce cost and operational overhead

### Simple Understanding
- VM = full house (you manage everything)
- ACI = hotel room (Azure manages everything)

### How it is done
- Used Docker image stored in Azure Container Registry
- Created an Azure Container Instance
- Provided:
  - ACR image name
  - Container port (80)
  - Public IP
- Azure automatically:
  - Pulled the image from ACR
  - Ran the container
  - Exposed the application to the internet

### Verification
- Accessed the container’s public IP in browser
- Website loaded successfully from Azure Container Instance

---

## Final Flow (End-to-End Understanding)

HTML  
↓  
Dockerfile  
↓  
Docker Image  
↓  
Azure Container Registry (ACR)  
↓  
Azure Container Instance (ACI)  
↓  
Website accessible on browser

---

## Assessment Outcome
- Docker installed and used to build container images
- Web application successfully containerized
- Docker image pushed to Docker Hub
- Docker image pushed to Azure Container Registry
- Container executed directly in Azure using ACI
- Understood VM-based vs serverless container execution
- Learned how Azure runs containers without managing servers
