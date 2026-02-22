# Day-15 

## Topic: Deploy Windows VM and Execute Custom Script at Logon Using Custom Script Extension

---

#  Objective

In this lab, we will:

* Create a **Windows Virtual Machine** using ARM Template
* Configure a **Custom Script Extension (CSE)**
* Register the script to run as a **Logon Task** (Task Scheduler)
* Automatically execute the script whenever a user logs into the VM

This approach is used in enterprises to:

* Install software at first login
* Configure developer environments
* Apply post-deployment customization
* Enforce machine-level automation

---

#  Architecture Flow

```
ARM Deployment
     ↓
Windows VM Created
     ↓
Custom Script Extension Executes
     ↓
Registers Scheduled Task (At Logon)
     ↓
User Logs In → Script Runs Automatically
```

---

#  What is Custom Script Extension?

Azure **Custom Script Extension** allows you to:

* Download scripts into the VM
* Execute PowerShell automatically
* Perform post-deployment configuration

It runs **inside the VM** after provisioning is complete.

---

#  Why Use Logon Task Instead of Direct Execution?

Sometimes configuration must run:

✔ When a user logs in
✔ With user profile loaded
✔ After domain join
✔ When GUI-dependent setup is required

That’s where **Windows Task Scheduler (At Logon Trigger)** is used.

---

#  Files Required

```
day15-template.json
day15-parameters.json
logon-script.ps1
```

---

#  Add ARM Template Below

Paste your ARM template in this section:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",

    "parameters": {
        "location": {
            "type": "string",
            "metadata": {
                "description": "Location for all resources."
            }
        },
        "vmName": {
            "type": "string",
            "metadata": {
                "description": "Name of the virtual machine."
            }
        },
        "adminUsername": {
            "type": "string",
            "metadata": {
                "description": "Admin username for the virtual machine."
            }
        },
        "adminPassword": {
            "type": "securestring",
            "metadata": {
                "description": "Admin password for the virtual machine."
            }
        },
        "vmSize": {
            "type": "string",
            "defaultValue": "Standard_DS1_v2",
            "metadata": {
                "description": "Size of the virtual machine."
            }
        },
        "vnetName": {
            "type": "string",
            "metadata": {
                "description": "Name of the virtual network."
            }
        },
        "subnetName": {
            "type": "string",
            "metadata": {
                "description": "Name of the subnet."
            }
        },
        "nsgName": {
            "type": "string",
            "metadata": {
                "description": "Name of the network security group."
            }
        },
        "publicIpName": {
            "type": "string",
            "metadata": {
                "description": "Name of the public IP address."
            }
        },
        "nicName": {
            "type": "string",
            "metadata": {
                "description": "Name of the network interface."
            }
        },
        "scriptFileUri": {
            "type": "string",
            "metadata": {
                "description": "URI of the script file to be executed on the virtual machine."
            }
        }
    },
    "variables": {
        "addressPrefix": "192.168.0.0/20",
        "subnetPrefix": "192.168.0.0/24"
    },
    "resources":[
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

    ]
}
```

---

#  Add Parameters File Below

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vmName": { 
        "value": "armWinVM01" 
        },
        "adminUsername": { 
        "value": "azureuser" 
        },
        "adminPassword": { 
        "value": "Azureuser@12" 
        },
        "location": { 
        "value": "West Us 2" 
        },
        "vmSize": { 
        "value": "Standard_B2as_v2" 
        },
        "vnetName": { 
        "value": "armVnet01" 
        },
        "subnetName": { 
        "value": "armSubnet01" 
        },
        "nsgName": { 
        "value": "armNsg01" 
        },
        "publicIpName": { 
        "value": "armPublicIp01" 
        },
        "nicName": {
        "value": "armNic01" 
        },
        "scriptFileUri": { 
        "value": "https://storageacc2002tf.blob.core.windows.net/task/script.ps1"
        }
    }
}
```

---

#  PowerShell Script Used by Custom Script Extension

Create a file named:

```
logon-script.ps1
```

This script will:

* Create a Scheduled Task
* Configure it to run at user logon
* Execute your desired automation

Paste your script here:

```powershell
# 1. Set Security Protocol to TLS 1.2 for modern downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. Install Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 3. Install Google Chrome and VS Code using Chocolatey
# -y automatically accepts all prompts
Write-Host "Installing Chrome and VS Code..."
choco install googlechrome vscode -y

# 4. Create a small script to install VS Code extensions at Logon
# (Extensions MUST be installed in the user context, not the SYSTEM context)
$ExtensionScript = @"
    # Wait for VS Code to be fully registered in the path
    Start-Sleep -Seconds 15
    & 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-vscode.powershell --force
    & 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-python.python --force
"@

$ExtensionScriptPath = "C:\Users\Public\install_extensions.ps1"
Set-Content -Path $ExtensionScriptPath -Value $ExtensionScript

# 5. Set Windows to run the extension script ONE TIME when you log in
$RunOnceCommand = "powershell.exe -ExecutionPolicy Bypass -File $ExtensionScriptPath"
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "InstallVSExtensions" -Value $RunOnceCommand

Write-Host "Provisioning complete. Apps will be there when you RDP in!"
```

---

#  What Happens During Deployment?

## Step-1: ARM Creates Windows VM

Azure provisions:

* OS Disk
* Networking
* Admin Credentials

---

## Step-2: Custom Script Extension Runs

Extension:

* Downloads `logon-script.ps1`
* Executes PowerShell silently
* Registers Windows Scheduled Task

---

## Step-3: Task Scheduler Entry Created

Task Configuration:

| Setting   | Value                    |
| --------- | ------------------------ |
| Trigger   | At Logon                 |
| Run Level | Highest Privilege        |
| User      | Any User / Specific User |
| Action    | Execute Script           |

---

## Step-4: User Logs into VM

When RDP login occurs:

```
Scheduled Task → Executes Script → Environment Configured
```

---

#  Deployment Command

```powershell
az login

az deployment group create `
--resource-group <RESOURCE_GROUP_NAME> `
--template-file day15-template.json `
--parameters day15-parameters.json
```

---

#  Validation Steps

After deployment:

1️ RDP into VM
2️ Open Task Scheduler:

```
taskschd.msc
```

3️ Verify task exists
4️ Log off → Log back in
5️ Confirm script executed

---

# How to Confirm Script Execution

Check:

| Location         | What to Look For    |
| ---------------- | ------------------- |
| Event Viewer     | Task Execution Logs |
| Custom Log File  | Output from script  |
| Installed Apps   | Expected changes    |
| Registry / Files | Created by script   |

---

#  Troubleshooting

| Issue              | Cause            | Fix                        |
| ------------------ | ---------------- | -------------------------- |
| Script not running | Execution Policy | Use Bypass                 |
| Task not created   | Extension failed | Check CSE logs             |
| Permission issue   | Not elevated     | Run with Highest Privilege |
| Script path wrong  | Download failed  | Validate URI               |

Check extension logs:

```
C:\WindowsAzure\Logs\Plugins\
```

---