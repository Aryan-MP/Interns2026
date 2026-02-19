# Day 10 – Bicep Deployment and Secure Access to Private VM via Public VM

## Project Overview

This project demonstrates Infrastructure as Code (IaC) using Bicep and implements a secure Azure network architecture.

The design ensures:

* A Private VM is not exposed to the internet.
* A Public VM acts as a secure gateway.
* Traffic is forwarded securely using Linux iptables NAT rules.
* Infrastructure is deployed using Azure CLI.

---

# Task 1 – Deploy a Storage Account Using Bicep

## Objective

* Write infrastructure using Bicep
* Deploy resources using Azure CLI
* Understand how Bicep simplifies ARM templates

---

## File: `storage.bicep`

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

```bash
az login

az deployment group create \
  --resource-group manoj-rg \
  --template-file storage.bicep \
  --parameters storageAccountName=<unique-storage-name>
```

---

## Validation

Navigate to Azure Portal → Resource Group → Verify the Storage Account has been created successfully.

---

# Task 2 – Secure Network with Public and Private VMs

## Objective

Deploy a secure architecture where:

* Public Subnet hosts a Gateway VM
* Private Subnet hosts a Web Server VM
* Private VM has no Public IP
* Access to the application is possible only through the Public VM
* Port forwarding is configured using iptables

---

# Architecture

```
Your Laptop
      ↓
Public VM (Gateway)
      ↓  (NAT / Port Forwarding)
Private VM (Web Server)
```

The Private VM is fully isolated from direct internet access.

---

# Network Design

Virtual Network: PortForwardVNet
Address Space: 10.0.0.0/16

Subnets:

* Public Subnet: 10.0.1.0/24
* Private Subnet: 10.0.2.0/24

Private VM IP: 10.0.2.10

---

# Bicep Template: `day10-network-vm.bicep`

The following template provisions:

* Network Security Group
* Virtual Network
* Public IP
* Public VM (Gateway)
* Private VM (Web Server)
* Nginx installation via Custom Script Extension
* Automatic iptables port forwarding configuration

---

## Template Code

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "adminUsername": {
            "defaultValue": "azureuser",
            "type": "String"
        },
        "adminPassword": {
            "defaultValue": "Azureuser@12",
            "type": "SecureString"
        },
        "location": {
            "defaultValue": "[resourceGroup().location]",
            "type": "String"
        },
        "vmSize": {
            "defaultValue": "Standard_DC1s_v3",
            "type": "String"
        }
    },
    "variables": {
        "vnetName": "PortForwardVNet",
        "publicSubnetName": "Public-Subnet",
        "privateSubnetName": "Private-Subnet",
        "publicVmName": "Gateway-VM",
        "privateVmName": "WebServer-VM",
        "publicIPName": "Gateway-Public-IP",
        "nsgName": "PortForward-NSG",
        "privateVmIP": "10.0.2.10"
    },
    "resources": [
        {
            "type": "Microsoft.Network/networkSecurityGroups",
            "apiVersion": "2020-06-01",
            "name": "[variables('nsgName')]",
            "location": "[parameters('location')]",
            "properties": {
                "securityRules": [
                    {
                        "name": "AllowSSH",
                        "properties": {
                            "priority": 1000,
                            "protocol": "Tcp",
                            "access": "Allow",
                            "direction": "Inbound",
                            "sourceAddressPrefix": "*",
                            "sourcePortRange": "*",
                            "destinationAddressPrefix": "*",
                            "destinationPortRange": "22"
                        }
                    },
                    {
                        "name": "AllowHTTP",
                        "properties": {
                            "priority": 1010,
                            "protocol": "Tcp",
                            "access": "Allow",
                            "direction": "Inbound",
                            "sourceAddressPrefix": "*",
                            "sourcePortRange": "*",
                            "destinationAddressPrefix": "*",
                            "destinationPortRange": "80"
                        }
                    }
                ]
            }
        }
    ]
}
```

(For brevity in this README example, only part of the template is shown. Full template is included in the repository file.)

---

# Deployment

```bash
az deployment group create \
  --resource-group manoj-rg \
  --template-file day10-network-vm.bicep \
  --parameters adminUsername=azureuser adminPassword=<YourPassword>
```

---

# Automatic Configuration

## Private VM

* Installs Nginx
* Deploys custom HTML page
* Starts and enables Nginx
* Listens on port 80

## Public VM

* Enables IP forwarding
* Configures NAT rules
* Forwards incoming HTTP traffic to Private VM

---

# Port Forwarding Logic

```bash
sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A PREROUTING -p tcp --dport 80 \
  -j DNAT --to-destination 10.0.2.10:80

iptables -t nat -A POSTROUTING -j MASQUERADE
```

Traffic Flow:

1. Browser sends request to Public VM.
2. Public VM forwards request to Private VM.
3. Private VM processes request using Nginx.
4. Response returns through Public VM.

---

# Access the Application

Open in browser:

```
http://<Public-VM-IP>
```

The page is served from the Private VM.

---

# Security Design

* Private VM has no Public IP.
* Only Public VM is internet-facing.
* NSG controls inbound traffic.
* Private subnet resources are isolated.
* Access occurs only via controlled port forwarding.

This follows a standard enterprise jump-host architecture pattern.

---

# Validation Checklist

| Component       | Expected Result        |
| --------------- | ---------------------- |
| Storage Account | Created via Bicep      |
| VNet            | Created                |
| Public VM       | Accessible             |
| Private VM      | No Public IP           |
| Nginx           | Installed              |
| Port Forwarding | Working                |
| Access Pattern  | Through Public VM Only |

---

# Conclusion

This project demonstrates secure infrastructure deployment using Bicep and Azure CLI. It implements a controlled access architecture where a Private VM remains protected within a private subnet and is accessed only through a Public gateway VM using NAT-based port forwarding.

This design minimizes exposure and aligns with enterprise security best practices.

---
