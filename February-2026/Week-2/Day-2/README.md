# Day 7 – Docker, Containers & Azure Container Registry (ACR)

## Author
Manoj Gowda

---

## Day 7 Objective
- Understand how applications are built and packaged using containers
- Learn Docker fundamentals
- Understand container-based application deployment
- Store Docker images securely in Azure Container Registry (ACR)
- Deploy and test a web application using Docker and Azure

---

## 1. Azure Virtual Machines – Recap and Context
Virtual Machines were revisited to understand where Docker runs.

### Key Understanding
- A Virtual Machine acts as a host machine
- Docker runs inside a VM
- VM provides:
  - Operating System
  - CPU
  - RAM
  - Network

Containers do not replace VMs.  
Containers usually run on top of VMs.

---

## 2. Docker Basics

### What is Docker
Docker is a containerization platform used to package applications with their dependencies.

### Image vs Container
- Image:
  - Blueprint or template
  - Read-only
  - Used to create containers
- Container:
  - Running instance of an image
  - Lightweight and fast

### Why Containers are Lightweight
- Share the host OS kernel
- No separate OS per container
- Faster startup than VMs
- Lower resource usage

### Understanding
- VM = OS + Application
- Container = Application only

---

## 3. Web Application Hosting Basics

### HTML Website
- Simple static website
- Uses HTML for content

### Nginx Web Server
- Lightweight web server
- Commonly used inside containers
- Serves static content

### Understanding
- Nginx listens on port 80
- Browser accesses application through port 80

---

## 4. Dockerfile and Image Creation

### What is a Dockerfile
A Dockerfile is a text file that contains instructions to build a Docker image.

### Instructions Learned
- FROM – base image (nginx)
- COPY – copy files into image
- EXPOSE – expose port
- CMD – start application

### Understanding
- Dockerfile converts application into a Docker image

---

## 5. Container Registries – Concept

### Docker Hub
- Public container registry
- Stores Docker images

### Why Azure Container Registry (ACR)
- Private registry
- Integrated with Azure
- Better security and control
- Suitable for production workloads

---

## 6. Azure Container Registry (ACR)

### What is ACR
Azure Container Registry is a private Docker image registry in Azure.

### Concepts Learned
- Repository – image name
- Tag – image version
- Authentication required to push and pull images

---

## 7. Day 7 Hands-On Summary
- Created Ubuntu Virtual Machine
- Installed Docker on VM
- Built a custom HTML web application
- Created Dockerfile
- Built Docker image
- Ran and tested containerized application
- Created Azure Container Registry
- Pushed Docker image to ACR
- Verified image in Azure

---

## 8. Day 7 Outcome
After Day 7, the following outcomes were achieved:
- Understood container-based application deployment
- Clearly explained Docker image vs container
- Packaged applications using Dockerfile
- Ran web applications using containers
- Used Azure Container Registry for image storage
- Connected Docker workflows with Azure services
