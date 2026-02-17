# Azure ARM Deployment Guide

This document explains how to perform the following tasks using **Azure ARM Templates**.

##  Task-1

Create a **Windows Virtual Machine** using ARM Template
Install **IIS Web Server** using **Custom Script Extension (CSE)**
Deploy a **Custom HTML Page**

##  Task-2

Create a **Managed Disk** using ARM Template
Attach the disk to the already created VM
Initialize and use the disk inside the VM

---

# 🔹 Prerequisites

Make sure you have:

* Active Azure Subscription
* Resource Group created
* Azure CLI installed (or use Azure Cloud Shell)
* RDP client to access Windows VM
* Required ports allowed:

  * **3389** → RDP
  * **80** → Web Access

---

# Project Structure

Create a working folder like below:

```
Azure-ARM-Lab/
│
├── task1-template.json
├── task1-parameters.json
├── install-iis.ps1
│
├── task2-template.json
├── task2-parameters.json
│
└── README.md
```

---

# 🚀 TASK-1 : Deploy Windows VM + IIS + Custom Web Page

---

## Step-1: Add ARM Template (VM Deployment)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",

  "parameters": {
    "vmName": { 
      "type": "string" 
    },
    "adminUsername": {
       "type": "string" 
    },
    "adminPassword": { 
      "type": "secureString" 
    },
    "location": { 
      "type": "string" 
    },
    "vmSize": {
      "type": "string" 
    },
    "vnetName": {
      "type": "string" 
    },
    "subnetName": {
      "type": "string" 
    },
    "nsgName": {
      "type": "string" 
    },
    "publicIpName": {
      "type": "string" 
    },
    "nicName": {
      "type": "string" 
    },
    "scriptFileUri": {
      "type": "string" 
    }
  },

  "variables": {
    "addressPrefix": "192.168.0.0/16",
    "subnetPrefix": "192.168.1.0/24"
  },

  "resources": [

    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-02-01",
      "name": "[parameters('nsgName')]",
      "location": "[parameters('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-RDP",
            "properties": {
              "priority": 1000,
              "direction": "Inbound",
              "access": "Allow",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "3389",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          },
          {

                "name": "Allow-HTTP",
                "properties": {
                "priority": 1001,
                "direction": "Inbound",
                "access": "Allow",
                "protocol": "Tcp",
                "sourcePortRange": "*",
                "destinationPortRange": "80",
                "sourceAddressPrefix": "*",
                "destinationAddressPrefix": "*"
                }
          }
        ]
      }
    },

    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2023-02-01",
      "name": "[parameters('vnetName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[parameters('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', parameters('nsgName'))]"
              }
            }
          }
        ]
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups', parameters('nsgName'))]"
      ]
    },

    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2023-02-01",
      "name": "[parameters('publicIpName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "Standard"
          },
      "properties": {
        "publicIPAllocationMethod": "Static"
      }
    },

    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-02-01",
      "name": "[parameters('nicName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/virtualNetworks', parameters('vnetName'))]",
        "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('vnetName'), parameters('subnetName'))]"
              },
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))]"
              }
            }
          }
        ]
      }
    },

    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', parameters('nicName'))]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "[parameters('vmSize')]"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsDesktop",
            "offer": "windows-11",
            "sku": "win11-25h2-pro",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', parameters('nicName'))]"
            }
          ]
        }
      }
    },

    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "apiVersion": "2023-03-01",
      "name": "[concat(parameters('vmName'), '/CustomScriptExtension')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines', parameters('vmName'))]"
      ],
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "CustomScriptExtension",
        "typeHandlerVersion": "1.10",
        "settings": {
          "fileUris": [
            "[parameters('scriptFileUri')]"
          ],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File script.ps1"
        }
      }
    }

  ],

  "outputs": {

  "vmName": {
    "type": "string",
    "value": "[parameters('vmName')]"
  },

  "vmId": {
    "type": "string",
    "value": "[resourceId('Microsoft.Compute/virtualMachines', parameters('vmName'))]"
  },

  "publicIPAddress": {
    "type": "string",
    "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))).ipAddress]"
  },

  "adminUsername": {
    "type": "string",
    "value": "[parameters('adminUsername')]"
  },

  "nicId": {
    "type": "string",
    "value": "[resourceId('Microsoft.Network/networkInterfaces', parameters('nicName'))]"
  },

  "nsgId": {
    "type": "string",
    "value": "[resourceId('Microsoft.Network/networkSecurityGroups', parameters('nsgName'))]"
  },

  "rdpConnectionCommand": {
    "type": "string",
    "value": "[concat('mstsc /v:', reference(resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))).ipAddress)]"
  }
}
}

```

---

## Step-2: Add Parameters File

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": { "value": "armWinVM01" },
    "adminUsername": { "value": "azureuser" },
    "adminPassword": { "value": "Azureuser@12" },
    "location": { "value": "eastus" },
    "vmSize": { "value": "Standard_DC2ds_v3" },
    "vnetName": { "value": "armVnet01" },
    "subnetName": { "value": "armSubnet01" },
    "nsgName": { "value": "armNsg01" },
    "publicIpName": { "value": "armPublicIp01" },
    "nicName": { "value": "armNic01" },
    "scriptFileUri": { 
      "value": "https://sga1102.blob.core.windows.net/scripts/script.ps1"
    }
  }
}

```

---

## Step-3: Add PowerShell Script (Custom Script Extension)

Create a script that installs IIS and deploys HTML.

```powershell
Write-Output "Starting Configuration..."

# ==============================
# Install IIS (Windows Desktop Method)
# ==============================

Write-Output "Enabling IIS Features..."

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole -All -NoRestart

Write-Output "IIS Enabled Successfully."

# ==============================
# Allow HTTP in Windows Firewall
# ==============================

Write-Output "Configuring Firewall..."

New-NetFirewallRule -DisplayName "Allow HTTP" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 80 `
  -Action Allow `
  -Profile Any `
  -ErrorAction SilentlyContinue

# ==============================
# Install Google Chrome
# ==============================

Write-Output "Downloading Chrome..."

$chromeInstaller = "$env:TEMP\chrome_installer.exe"

Invoke-WebRequest `
  -Uri "https://dl.google.com/chrome/install/latest/chrome/install_chrome.exe" `
  -OutFile $chromeInstaller

Write-Output "Installing Chrome..."

Start-Process -FilePath $chromeInstaller -ArgumentList "/silent /install" -Wait

Write-Output "Chrome Installed Successfully."

# ==============================
# Remove Default IIS Page
# ==============================

$defaultPage = "C:\inetpub\wwwroot\iisstart.htm"

if (Test-Path $defaultPage) {
    Remove-Item $defaultPage -Force
}

# ==============================
# Create Custom HTML Page
# ==============================

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>ARM Deployment Success</title>
    <style>
        body {
            background-color: #111827;
            color: #ffffff;
            font-family: Arial;
            text-align: center;
            padding-top: 100px;
        }
        h1 {
            font-size: 48px;
            color: #22c55e;
        }
        .box {
            border: 2px solid #22c55e;
            padding: 20px;
            border-radius: 12px;
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1> ARM Deployment Successful</h1>
    <div class="box">
        <p>IIS Installed on Windows 11</p>
        <p>Google Chrome Installed</p>
        <p>Custom Script Extension Executed</p>
    </div>
</body>
</html>
"@

Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value $html -Force

Write-Output "Restarting IIS..."

# Restart IIS Service
iisreset

Write-Output "Configuration Completed Successfully."

```

---

## Step-4: Deploy the Template

Login to Azure:

```bash
az login
```

Set Subscription:

```bash
az account set --subscription "<SUBSCRIPTION_ID>"
```

Run Deployment:

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file task1-template.json \
  --parameters task1-parameters.json
```

---

## Step-5: Validate Web Server

After deployment:

Get Public IP from Azure Portal.

Open browser:

```
http://<Public-IP>
```

 Your Custom HTML page should load.

---

## Step-6: Verify Inside VM

Connect using RDP:

```
mstsc → <Public-IP>
```

Check IIS:

```
C:\inetpub\wwwroot
```

Your HTML file should exist.

---

# 💾 TASK-2 : Create and Attach Managed Disk

---

## Step-1: Add Disk ARM Template

Paste your **Disk Creation + Attach Template** below:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",

  "parameters": {
    "vmName": {
      "type": "string",
      "metadata": {
        "description": "Name of the virtual machine to which the disk will be attached"
      }
    },
    "diskName": {
      "type": "string",
      "metadata": {
        "description": "Name of the managed disk to be created and attached to the VM"
      }
    },
    "diskSizeGB": {
      "type": "int",
      "defaultValue": 512
    }
  },

  "resources": [

    {
      "type": "Microsoft.Compute/disks",
      "apiVersion": "2023-04-02",
      "name": "[parameters('diskName')]",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "properties": {
        "creationData": {
          "createOption": "Empty"
        },
        "diskSizeGB": "[parameters('diskSizeGB')]"
      }
    },

    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[parameters('vmName')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Compute/disks', parameters('diskName'))]"
      ],
      "properties": {
        "storageProfile": {
          "dataDisks": [
            {
              "lun": 1,
              "name": "[parameters('diskName')]",
              "createOption": "Attach",
              "managedDisk": {
                "id": "[resourceId('Microsoft.Compute/disks', parameters('diskName'))]"
              }
            }
          ]
        }
      }
    }

  ]
}

```

---

## Step-2: Add Parameters File

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "14.0.0.0",

"vmname": { 
  "value": "armWinVM01"
  },
"diskName": {
  "value": "armDataDisk01"
  }
}
```

---

## Step-3: Deploy Disk Template

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file task2-template.json \
  --parameters task2-parameters.json
```

---

## Step-4: Initialize Disk in VM

RDP into VM.

Open Disk Management:

```
diskmgmt.msc
```

You will see a new disk.

### Perform:

1. Right Click → **Online**
2. Initialize Disk (GPT)
3. New Simple Volume
4. Assign Drive Letter (Example: F:)
5. Format → NTFS

---

## Step-5: Validate Disk

Open:

```
This PC
```

New drive should appear.

---