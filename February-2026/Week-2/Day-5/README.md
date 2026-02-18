
# Day 10 – Bicep Deployment and Secure Access to Private VM via Public VM

## Project Overview

This project demonstrates Infrastructure as Code using Bicep and implements a secure network architecture in Azure. The design ensures that a Private VM is not directly exposed to the internet and can only be accessed through a Public VM acting as a gateway using port forwarding.

The project is divided into two tasks:

1. Deploy a Storage Account using Bicep.
2. Deploy a Virtual Network with Public and Private subnets, two VMs, and configure secure access via port forwarding.

---

# Task 1 – Create a Storage Account Using Bicep

## Objective

* Write infrastructure using Bicep.
* Deploy resources using Azure CLI.
* Understand how Bicep simplifies ARM templates.

---

## File: storage.bicep

```bicep
param storageAccountName string
param location string = resourceGroup().location

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageId string = storage.id
```

---

## Deployment

Login to Azure:

```bash
az login
```

Deploy the template:

```bash
az deployment group create \
  --resource-group manoj-rg \
  --template-file storage.bicep \
  --parameters storageAccountName=<unique-storage-name>
```

---

## Validation

Navigate to Azure Portal → Resource Group → Verify that the Storage Account has been created successfully.

---

# Task 2 – Secure VNet with Public and Private VMs

## Objective

Design and deploy a secure network architecture where:

* A Public VM acts as a gateway.
* A Private VM hosts the application.
* The Private VM has no public IP.
* Access to the Private VM is only possible through the Public VM using port forwarding.

---

# Architecture

```
Your Laptop
      ↓
Public VM (Gateway / Jump Host)
      ↓ (Port Forwarding)
Private VM (Application Server)
```

The Private VM is not directly accessible from the internet.

---

# Network Design

Virtual Network: PortForwardVNet
Address Space: 10.0.0.0/16

Subnets:

* Public Subnet: 10.0.1.0/24
* Private Subnet: 10.0.2.0/24

---

# Bicep Template: day10-network-vm.bicep

This template provisions:

* Network Security Group
* Virtual Network with Public and Private subnets
* Public IP Address
* Public VM (Gateway)
* Private VM (Web Server)
* Nginx installation using Custom Script Extension
* Port forwarding configuration on Public VM

Deployment automatically:

* Installs Nginx on Private VM
* Deploys a custom HTML page
* Configures iptables on Public VM to forward traffic

---

## Deploy the Environment

```bash
az deployment group create \
  --resource-group manoj-rg \
  --template-file day10-network-vm.bicep \
  --parameters adminUsername=azureuser adminPassword=<YourPassword>
```

---

# Application Setup on Private VM

The Custom Script Extension performs the following:

* Updates package repository
* Installs Nginx
* Creates a custom HTML page
* Enables and starts Nginx service

The application listens on port 80 inside the Private VM.

---

# Port Forwarding Configuration (Linux – iptables)

On the Public VM, IP forwarding and NAT rules are configured:

```bash
sudo sysctl -w net.ipv4.ip_forward=1

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 \
  -j DNAT --to-destination 10.0.2.10:80

sudo iptables -t nat -A POSTROUTING -j MASQUERADE
```

This ensures that:

* Traffic arriving at Public VM on port 80
* Is forwarded internally to Private VM on port 80

---

# Access the Application

Open a browser and navigate to:

```
http://<Public-VM-IP>
```

The request flow:

1. Browser sends request to Public VM.
2. Public VM forwards traffic to Private VM using private IP.
3. Private VM serves the Nginx page.
4. Response is returned through the Public VM.

The Private VM remains isolated from direct internet access.

---

# Security Design

* Private VM has no Public IP.
* All inbound traffic is controlled via NSG.
* Only Public VM is exposed to the internet.
* Private subnet resources are protected.
* Port forwarding provides controlled access.

This architecture follows a secure jump-host pattern commonly used in enterprise environments.

---

# Validation Checklist

| Component       | Status Requirement     |
| --------------- | ---------------------- |
| Storage Account | Created via Bicep      |
| Virtual Network | Created                |
| Public VM       | Accessible             |
| Private VM      | No Public IP           |
| Application     | Installed and Running  |
| Port Forwarding | Functional             |
| Access Pattern  | Through Public VM Only |

---

# Key Concepts Demonstrated

* Infrastructure as Code using Bicep
* Secure network segmentation
* Public vs Private subnet architecture
* Network Security Groups
* Linux port forwarding using DNAT and MASQUERADE
* Azure Custom Script Extension
* Secure access to internal resources

---

# Conclusion

This project demonstrates secure infrastructure deployment using Bicep and Azure CLI. It implements a controlled access pattern where a Private VM remains protected within a private subnet and is accessed through a Public VM using port forwarding. This design minimizes exposure and aligns with enterprise security best practices.

---
