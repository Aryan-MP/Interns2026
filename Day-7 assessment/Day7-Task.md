
# Docker → Docker Hub → Azure Container Registry → Azure Container Instance  
**Lab / Hands-on Summary**

## Overview
This lab covers the complete container workflow starting from installing Docker on a Virtual Machine, running and customizing an NGINX container, using volumes for persistence, pushing images to Docker Hub and Azure Container Registry (ACR), and finally deploying the image to Azure Container Instance (ACI).

---

## Task 1 — Install Docker & Run NGINX on VM
**Objective:** Run a basic NGINX container and host a custom web page.

### Steps Performed
1. Installed Docker inside Linux VM.
2. Pulled latest NGINX image from Docker Hub:
   docker pull nginx:latest
3. Ran NGINX container:
   docker run -d -p 80:80 --name nginx-server nginx
4. Created custom HTML page and hosted via NGINX.
5. Allowed HTTP (Port 80) in Azure VM Networking / Firewall.

**Result:** NGINX page accessible via VM Public IP.

---

## Task 2 — Volume Mounting & Data Persistence
**Objective:** Ensure website persists even after container deletion.

### Steps Performed
1. Mounted bind volume:
   docker run -d -p 80:80 --name nginx-server -v /home/azureuser/mysite:/usr/share/nginx/html nginx
2. Deleted container.
3. Recreated container with same mounted volume.
4. Verified NGINX still served the same webpage.

**Result:** Data persisted successfully using Docker Volume.

---

## Task 3 — Modify Running Container using docker exec
**Objective:** Update HTML inside running container.

### Steps Performed
1. Entered running container:
   docker exec -it nginx-server bash
2. Modified HTML file inside container.
3. Verified changes reflected instantly in browser.

**Result:** Successfully modified live container content.

---

## Task 4 — Push Local Image to Docker Hub
**Objective:** Upload Docker image to Docker Hub.

### Steps Performed
1. Logged into Docker Hub:
   docker login
2. Tagged image:
   docker tag nginx:latest <dockerhub-username>/nginx:v1
3. Pushed image:
   docker push <dockerhub-username>/nginx:v1

**Result:** Image successfully uploaded to Docker Hub repository.

---

## Task 5 — Push Local Image to Azure Container Registry (ACR)
**Objective:** Store Docker image in Azure private registry.

### Steps Performed
1. Logged into ACR using Admin credentials:
   docker login <acr-login-server>
2. Tagged image:
   docker tag nginx:latest <acr-login-server>/nginx:v1
3. Pushed image:
   docker push <acr-login-server>/nginx:v1

**Result:** Image visible in ACR → Repositories.

---

## Task 6 — Deploy Image from ACR → Azure Container Instance (ACI)
**Objective:** Run container publicly using Azure Container Instance.

### Steps Performed
1. Imported image (Docker Hub → ACR via Portal).
2. Created Azure Container Instance using ACR image.
3. Enabled Public IP and exposed Port 80.
4. Verified container running.

**Result:** NGINX container successfully deployed and accessible via Public IP / DNS.

---

## Final Outcome
Successfully completed full container lifecycle:

- Docker installed on VM  
- NGINX container deployed and customized  
- Volume persistence implemented  
- Running container modified using docker exec  
- Image pushed to Docker Hub  
- Image pushed to Azure Container Registry  
- Container deployed using Azure Container Instance  

---

## Technologies Used
- Docker  
- Docker Hub  
- Azure Virtual Machine  
- Azure Container Registry (ACR)  
- Azure Container Instance (ACI)  
- NGINX  

---

