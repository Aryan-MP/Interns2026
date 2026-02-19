This ARM template deploys:

✔ 1 Virtual Network  
✔ 1 Subnet  
✔ 2 Linux Virtual Machines  
✔ NGINX installed on both VMs  
✔ Custom index.html for each VM  
✔ Azure Standard Public Load Balancer  
✔ Load Balancing Rule on Port 8080  
✔ Health Probe  
✔ Output = Load Balancer Public IP  

---

## 🏗 Architecture

```
Internet
   ↓
Public IP
   ↓
Azure Standard Load Balancer (Port 8080)
   ↓
Backend Pool
   ↓
VM1 (Nginx)
VM2 (Nginx)
```

---

## 🖥 VM Configuration

### VM1

Displays:
```
This request is going to VM1 Nginx server
```

### VM2

Displays:
```
This request is going to VM2 Nginx server
```

Both NGINX servers run on:
```
Port 8080
```

---

## ⚙ Load Balancer Configuration

| Component | Value |
|------------|--------|
| Type | Standard |
| Frontend Port | 8080 |
| Backend Port | 8080 |
| Health Probe | TCP 8080 |
| Backend Pool | VM1 + VM2 |

---

## 🚀 Deployment Steps

### 1️⃣ Login

```
az login
```

### 2️⃣ Create Resource Group

```
az group create --name myRG --location eastus
```

### 3️⃣ Deploy ARM Template

```
az deployment group create \
  --resource-group myRG \
  --template-file nginx-2vm-standard-lb.json \
  --parameters adminPassword=<YourPassword>
```

---

## 🌍 Access Application

After deployment, copy the output:

```
LoadBalancerPublicIP
```

Open in browser:

```
http://<PublicIP>:8080
```

Refresh multiple times.

You will see traffic switching between:

✔ VM1  
✔ VM2  
