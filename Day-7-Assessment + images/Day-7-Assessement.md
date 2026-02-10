# Docker and NGINX Hands-on Tasks Documentation

---

## Task 1: Run NGINX Web Application Using Docker in an Ubuntu VM

### Step 1: Create an Ubuntu Virtual Machine
- Create a Virtual Machine with **Ubuntu OS** from Azure Portal.
- Configure:
  - VM size
  - Username and SSH key/password
  - Networking (VNet, Subnet, Public IP)
- Launch the VM and connect using SSH:
```bash
ssh azureuser@<VM-PUBLIC-IP>
```

---

### Step 2: Install Docker on the Ubuntu VM

Update the system:
```bash
sudo apt update
```

Install Docker:
```bash
sudo apt install docker.io -y
```

Start and enable Docker:
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Verify Docker installation:
```bash
docker --version
```

(Optional) Run Docker without sudo:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

### Step 3: Pull NGINX Image and Run Container on Port 8080

Pull the NGINX image from Docker Hub:
```bash
docker pull nginx
```

Run the NGINX container:
```bash
docker run -d -p 8080:80 --name nginx-container nginx
```

Verify container is running:
```bash
docker ps
```

---

## Task 2: Attach Docker Volumes to the Running Container

### Step 1: Create a Docker Volume
```bash
docker volume create nginx-volume
```

Verify volume:
```bash
docker volume ls
```

---

### Step 2: Attach Volume While Creating Container

Stop and remove existing container:
```bash
docker stop nginx-container
docker rm nginx-container
```

Run container with volume attached:
```bash
docker run -d -p 8080:80 --name nginx-container -v nginx-volume:/usr/share/nginx/html nginx
```

---

### Step 3: Add Files to the Mounted Path

Create a custom index file:
```bash
docker exec -it nginx-container bash
```

Inside container:
```bash
echo "<h1>Hello from Docker Volume</h1>" > /usr/share/nginx/html/index.html
exit
```

---

### Step 4: Delete Container and Verify Volume Persistence

Remove the container:
```bash
docker rm -f nginx-container
```

Check volume data location on host:
```bash
sudo ls /var/lib/docker/volumes/nginx-volume/_data
```

Files still exist, proving **data persistence**.

---

## Task 3: Accessing the Web Application Using NGINX

### Step 1: Access Application via Browser

Ensure:
- VM Network Security Group allows **port 8080**
- Docker container is running

Access the application:
```
http://<VM-PUBLIC-IP>:8080
```

You should see:
```
Hello from Docker Volume
```

---

## Task 4: Push the Docker Image to Azure Container Registry (ACR)

### Step 1: Create Azure Container Registry
- Create ACR from Azure Portal
- Enable **Admin user**
- Note:
  - Login Server
  - Username
  - Password

---

### Step 2: Login to Azure Container Registry
```bash
az login 
az acr login --name demogreg
```

---

### Step 3: Tag the NGINX Image
```bash
docker tag nginx demogreg.azurecr.io/nginx:v1
```

---

### Step 4: Push Image to ACR
```bash
docker push demogreg.azurecr.io/nginx:v1
```

<img src="Screenshot 2026-02-10 232551.png">
<img src="Screenshot (19).png">
---

### Step 5: Verify Image in ACR
- Open Azure Portal
- Navigate to ACR → Repositories
- Verify `nginx:v1` image is available

---

<img src="Screenshot (18).png">
---


<img src="Screenshot 2026-02-10 221545.png">

---