## 🚀 Azure ARM Template Deployment Projects

This repository contains **4 Azure ARM Template deployment tasks** demonstrating Infrastructure as Code (IaC) using JSON templates.

---

## 📌 Project Overview

This project showcases how to deploy and configure Azure resources programmatically using ARM Templates.

It includes:

| Task | Resource |
|------|----------|
| Task 1 | Windows VM + IIS + Networking |
| Task 2 | Storage Account + Container |
| Task 3 | Attach Managed Disk to VM |
| Task 4 | Azure Container Registry |

---

## 🧱 Architecture Flow

```
User → ARM Template → Azure Resource Manager → Azure Resources
```

---

## 🛠 Prerequisites

Install and login Azure CLI:

```bash
az login
```

Verify subscription:

```bash
az account show
```

---

## 📂 Repository Structure

```
├── task1-vm.json
├── task2-storage.json
├── task3-disk.json
├── task4-acr.json
└── README.md
```

---

## 🖥 Task 1 — Windows VM + IIS ARM Template

This ARM template deploys:

- Virtual Network
- Subnet
- Public IP
- Network Security Group
- Network Interface
- Windows Server 2022 VM
- IIS Web Server (auto-installed)

---

### 📄 Template Code

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": {
      "type": "string"
    },
    "adminPassword": {
      "type": "secureString"
    }
  },
  "variables": {
    "vmName": "Windows1ARM",
    "vnetName": "myVNet",
    "subnetName": "mySubnet",
    "nsgName": "myNSG",
    "publicIPName": "myPublicIP",
    "nicName": "myNIC"
  },
  "resources": [
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2023-04-01",
      "name": "[variables('publicIPName')]",
      "location": "[resourceGroup().location]",
      "sku": { "name": "Standard" },
      "properties": {
        "publicIPAllocationMethod": "Static",
        "publicIPAddressVersion": "IPv4"
      }
    },
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-04-01",
      "name": "[variables('nsgName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-HTTP",
            "properties": {
              "priority": 1000,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "80"
            }
          },
          {
            "name": "Allow-RDP",
            "properties": {
              "priority": 1010,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "3389"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2023-04-01",
      "name": "[variables('vnetName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["10.0.0.0/16"]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "10.0.0.0/24"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-04-01",
      "name": "[variables('nicName')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))]",
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]",
        "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('subnetName'))]"
              },
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))]"
              }
            }
          }
        ],
        "networkSecurityGroup": {
          "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
        }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[variables('vmName')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_L2aos_v4"
        },
        "osProfile": {
          "computerName": "[variables('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "2022-datacenter-g2",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "apiVersion": "2023-03-01",
      "name": "[concat(variables('vmName'), '/IISInstall')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines', variables('vmName'))]"
      ],
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "CustomScriptExtension",
        "typeHandlerVersion": "1.10",
        "settings": {
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; echo '<h1>Hello Denith,How are you - IIS Installed via ARM + CSE</h1>' > C:\\\\inetpub\\\\wwwroot\\\\index.html\""
        }
      }
    }
  ]
}
```

---

## 🚀 Deployment Command

```bash
az deployment group create \
 --resource-group <RG_NAME> \
 --template-file template.json \
 --parameters adminUsername=azureuser adminPassword=<Password>
```
<img src="Screenshot (23).png" alt="">


## 💾 Task 2 — Storage Account + Container

### Resources Created

- Storage Account
- Blob Container

### Deploy

```bash
az deployment group create \
 --resource-group <RG_NAME> \
 --template-file task2-storage.json \
 --parameters storageAccountName=<uniqueName>
```
<img src="Screenshot (22).png" alt="">
---

## 💽 Task 3 — Attach Data Disk to Existing VM

Creates and attaches a **managed disk** to an existing VM.

### Deploy

```bash
az deployment group create \
 --resource-group <RG_NAME> \
 --template-file task3-disk.json \
 --parameters vmName=<VM_NAME>
```
<img src="Screenshot (24).png" alt="">
---

## 📦 Task 4 — Azure Container Registry

Deploys an ACR instance.

### Deploy

```bash
az deployment group create \
 --resource-group <RG_NAME> \
 --template-file task4-acr.json \
 --parameters registryName=<uniqueRegistryName>
```

---

## 🧠 Key Concepts Demonstrated

- Infrastructure as Code
- ARM Template syntax
- Parameters & Variables
- Resource dependencies
- Managed disks
- VM Extensions
- Networking
- Storage provisioning
- Container Registry automation

---

## 🔎 Template Validation Command

Always validate template before deploying:

```bash
az deployment group validate \
 --resource-group denithmathewek-rg \
 --template-file template.json
```

---

## 🏆 Skills Demonstrated

✔ Azure ARM Templates  
✔ Cloud Infrastructure Automation  
✔ Networking Configuration  
✔ Compute Deployment  
✔ Storage Provisioning  
✔ Container Registry Setup  

---

## 📈 Real-World Use Cases

- Automated Dev/Test environments
- CI/CD infrastructure provisioning
- Disaster recovery setups
- Repeatable enterprise deployments

---

## 👨‍💻 Author

**Denith**

---

## ⭐ Best Practices Followed

- Parameterized templates
- Resource dependency ordering
- Secure password handling
- Modular deployment approach

---

## 📜 License

This project is for learning and demonstration purposes.

---

## 🎯 Conclusion

This repository demonstrates how Azure infrastructure can be deployed fully automatically using ARM templates without manual portal configuration.

---

⭐ If you found this useful, consider starring the repo!