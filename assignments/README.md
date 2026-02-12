
# 🚀 Azure ARM Templates Project

## 📌 Overview
This project demonstrates Infrastructure as Code (IaC) using Azure Resource Manager (ARM) templates.

The templates deploy:
- Azure Container Instance (Public Image)
- Azure Container Instance (Private ACR Image)
- Azure Container Registry (ACR)
- Windows Virtual Machine with IIS (using Custom Script Extension)

---

## 📂 ARM Template Files

### 1️⃣ Azure Container Instance – Public Image
Deploys a container using Microsoft public image (aci-helloworld).

File: aci-public.json

Features:
- Linux container
- Public IP enabled
- Port 80 exposed
- Restart policy: Always

Deployment Command:
```bash
az deployment group create \
  --resource-group <your-rg> \
  --template-file aci-public.json
```

---

### 2️⃣ Azure Container Instance – Private ACR Image
Deploys container from Azure Container Registry.

File: aci.json

Features:
- Uses ACR image
- Requires ACR username & password
- Public IP enabled
- Port 80 exposed

Deployment Command:
```bash
az deployment group create \
  --resource-group <your-rg> \
  --template-file aci.json \
  --parameters acrUsername=<username> acrPassword=<password>
```

---

### 3️⃣ Azure Container Registry (ACR)
Creates a Basic SKU Azure Container Registry with admin enabled.

File: acr.json

Deployment Command:
```bash
az deployment group create \
  --resource-group <your-rg> \
  --template-file acr.json \
  --parameters acrName=<acr-name>
```

---

### 4️⃣ Windows VM with IIS (Custom Script Extension)
Creates complete Windows VM infrastructure:

Resources Created:
- Virtual Network
- Subnet
- Network Security Group (HTTP + RDP)
- Public IP (Static)
- Network Interface
- Windows Server 2022 VM
- IIS installed automatically via Custom Script Extension

File: azuredeploy.json

Deployment Command:
```bash
az deployment group create \
  --resource-group <your-rg> \
  --template-file azuredeploy.json \
  --parameters adminUsername=<username> adminPassword=<password>
```

---

## 🛠 Technologies Used
- Azure Resource Manager (ARM)
- Azure Container Instance
- Azure Container Registry
- Azure Virtual Machine
- Custom Script Extension (CSE)
- Azure CLI

---

## 🎯 Purpose of Project
This project demonstrates:
- Infrastructure as Code (IaC)
- Parameterized ARM templates
- Public & Private container deployments
- VM automation using extensions
- Real-world Azure deployment scenarios

---
Storage Account creation using ARM templete
az deployment group create \
  --resource-group <your-rg> \
  --template-file storage.json \
  --parameters storageAccountName="  "
---


