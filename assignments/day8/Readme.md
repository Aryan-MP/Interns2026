End-to-End Docker Deployment on Azure (VM → ACR → ACI)

This project demonstrates a complete container lifecycle workflow on Microsoft Azure:

✅ Create Azure Linux Virtual Machine

✅ Install Docker

✅ Pull image from Public Registry

✅ Create container with volume mapping

✅ Modify index.html

✅ Create Azure Container Registry (ACR)

✅ Push custom image to ACR

✅ Deploy Azure Container Instance (ACI)

✅ Pull image from ACR

✅ Access web application

This assignment showcases real-world DevOps and container deployment practices.
Azure Linux VM
      ↓
Install Docker
      ↓
Pull Nginx from Docker Hub
      ↓
Run Container + Mount Volume
      ↓
Modify index.html
      ↓
Tag & Push Image to ACR
      ↓
Deploy ACI from ACR
      ↓
Access Web Application


Step 1 – Create Azure Linux VM

Create a Linux VM from Azure Portal or Azure CLI.

Example CLI:  az vm create \
  --resource-group kiranupatil-rg \
  --name myVM \
  --image UbuntuLTS \
  --admin-username azureuser \
  --generate-ssh-keys

Open Port 80: az vm open-port --port 80 --resource-group kiranupatil-rg  --name myVM

Step 2 – Install Docker in VM

SSH into VM:sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

Verify:docker --version

Step 3 – Pull Image from Public Registry

Pull Nginx from Docker Hub:docker pull nginx
Step 4 – Create Container with Volume

Create local directory:mkdir html

Step 4 – Create Container with Volume

Create local directory:docker run -d -p 80:80 \
  --name mynginx \
  -v $(pwd)/html:/usr/share/nginx/html \
  nginx

Step 5 – Replace index.html

Create custom page: nano html/index.html
<h1>Docker Running on Azure VM</h1>
<h2>Custom Page Deployed Successfully</h2>

Access:http://20.204.178.91

Step 6 – Create Azure Container Registry (ACR)

Create ACR:az acr create \
  --resource-group kiranupatil-rg \
  --name myacr2026 \
  --sku Basic

Login to ACR:az acr login --name myacr2026

Step 7 – Tag & Push Image to ACR

Tag image:

docker tag nginx myacr2026.azurecr.io/myapp:v1

Push image:

docker push myacr2026.azurecr.io/myapp:v1

Step 8 – Create Azure Container Instance (ACI)

Deploy container from ACR:

az container create \
  --resource-group kiranupatil-rg \
  --name mycontainer \
  --image myacr2026.azurecr.io/myapp:v1 \
  --registry-login-server myacr2026.azurecr.io \
  --registry-username azureuser \
  --registry-password X7mL9qR2vT8kZp4HsW3n
 \
  --ip-address Public \
  --ports 80


