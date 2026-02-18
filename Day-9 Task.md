
# DAY-9

Now we move from **single-resource deployment** to **multi-resource orchestration and conditional deployments**.

---

## TASK-1

Create:

* Virtual Machine
* Storage Account
* Azure Container Registry (ACR)

and **observe the deployment flow**.

---

## Step-1: Add ARM Template

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
    "storageAccountName": {
         "type": "string" 
    },
    "acrName": { 
        "type": "string" 
    }
  },

  "variables": {
    "vnetName": "day9-vnet",
    "subnetName": "default",
    "publicIPName": "day9-pip",
    "nicName": "day9-nic",
    "nsgName": "day9-nsg",
    "vmSize": "Standard_B2s"
  },

  "resources": [

    // ---------------------------
    // Storage Account
    // ---------------------------
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2023-01-01",
      "name": "[parameters('storageAccountName')]",
      "location": "[parameters('location')]",
      "sku": { "name": "Standard_LRS" },
      "kind": "StorageV2",
      "properties": {}
    },

    // ---------------------------
    // Azure Container Registry
    // ---------------------------
    {
      "type": "Microsoft.ContainerRegistry/registries",
      "apiVersion": "2023-01-01-preview",
      "name": "[parameters('acrName')]",
      "location": "[parameters('location')]",
      "sku": { "name": "Basic" },
      "properties": {
        "adminUserEnabled": true
      }
    },

    // ---------------------------
    // Network Security Group
    // ---------------------------
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-02-01",
      "name": "[variables('nsgName')]",
      "location": "[parameters('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-RDP",
            "properties": {
              "priority": 100,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "destinationPortRange": "3389",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          }
        ]
      }
    },

    // ---------------------------
    // Virtual Network
    // ---------------------------
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2023-02-01",
      "name": "[variables('vnetName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
      ],
      "properties": {
        "addressSpace": {
          "addressPrefixes": [ "10.0.0.0/16" ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "10.0.0.0/24",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
              }
            }
          }
        ]
      }
    },

    // ---------------------------
    // Public IP
    // ---------------------------
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2023-02-01",
      "name": "[variables('publicIPName')]",
      "location": "[parameters('location')]",
      "sku": { "name": "Standard" },
      "properties": {
        "publicIPAllocationMethod": "Static"
      }
    },

    // ---------------------------
    // NIC
    // ---------------------------
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-02-01",
      "name": "[variables('nicName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]",
        "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))]"
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
        ]
      }
    },

    // ---------------------------
    // Virtual Machine
    // ---------------------------
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]",
        "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]",
        "[resourceId('Microsoft.ContainerRegistry/registries', parameters('acrName'))]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "[variables('vmSize')]"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "2019-Datacenter",
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
    }
  ]
}


---

## Step-2: Add Parameters

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": { 
        "value": "day9-vm" 
    },
    "adminUsername": { 
        "value": "azureuser" 
    },
    "adminPassword": { 
        "value": "YourStrongPassword@123" 
    },
    "location": { 
        "value": "eastus" 
    },
    "storageAccountName": {
         "value": "day9storage12345" 
    },
    "acrName": {
        "value": "day9acr12345" 
    }
  }
}

```

---

## Step-3: Deploy

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file day9-task1-template.json \
  --parameters day9-task1-parameters.json
```

---

## Step-4: Observe Deployment Flow

Go to:

```
Azure Portal → Resource Group → Deployments
```

You will see the execution timeline like a build pipeline:

1️⃣ Storage Account created
2️⃣ Container Registry created
3️⃣ Networking resources created
4️⃣ Virtual Machine created

This demonstrates **ARM dependency chaining using `dependsOn`**.

---

## Validation

| Resource         | Check                  |
| ---------------- | ---------------------- |
| Storage Account  | Created successfully   |
| ACR              | Login server available |
| VM               | Running                |
| Deployment Order | Verified in timeline   |

---

#  TASK-2

Create **ONE reusable ARM Template** that can deploy:

* Windows VM **OR**
* Ubuntu VM

based on user selection.

This is called a **Conditional Deployment Template**.

---

## Concept Used

* Parameters
* Conditions
* Variables
* Conditional Image Reference

The template behaves like a switch.

```
If OS = Windows → Deploy Windows VM
If OS = Ubuntu → Deploy Linux VM
```

---

## Step-1: Add Conditional Template

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "14.0.0.0",

  "parameters": {
    "ubuntuVmCount": {
      "type": "int",
      "minValue": 0,
      "maxValue": 100,
      "defaultValue": 0
    },
    "windowsVmCount": {
      "type": "int",
      "minValue": 0,
      "maxValue": 100,
      "defaultValue": 0
    },
    "adminUsername": {
      "type": "string",
      "defaultValue": "Azureuser"
    },
    "adminPassword": {
      "type": "secureString"
    }
  },

  "variables": {
    "location": "[resourceGroup().location]",
    "vnetName": "ProdVnet",
    "subnetName": "main-subnet",
    "ubuntuNsg": "Ubuntu-NSG",
    "windowsNsg": "Windows-NSG",
    "ubuntuScriptUrl": "https://storageac1202.blob.core.windows.net/task/install-nginx.sh",
    "windowsScriptUrl": "https://storageac1202.blob.core.windows.net/task/install-iis.ps1"
  },

  "resources": [

    // ================= NSGs =================

    {
      "condition": "[greater(parameters('ubuntuVmCount'), 0)]",
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-04-01",
      "name": "[variables('ubuntuNsg')]",
      "location": "[variables('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-SSH",
            "properties": {
              "priority": 100,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationPortRange": "22",
              "destinationAddressPrefix": "*"
            }
          },
          {
            "name": "Allow-HTTP",
            "properties": {
              "priority": 110,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationPortRange": "80",
              "destinationAddressPrefix": "*"
            }
          }
        ]
      }
    },

    {
      "condition": "[greater(parameters('windowsVmCount'), 0)]",
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-04-01",
      "name": "[variables('windowsNsg')]",
      "location": "[variables('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-RDP",
            "properties": {
              "priority": 100,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationPortRange": "3389",
              "destinationAddressPrefix": "*"
            }
          },
          {
            "name": "Allow-HTTP",
            "properties": {
              "priority": 110,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationPortRange": "80",
              "destinationAddressPrefix": "*"
            }
          }
        ]
      }
    },

    // ================= VNET + SINGLE SUBNET =================

    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2023-04-01",
      "name": "[variables('vnetName')]",
      "location": "[variables('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [ "10.1.0.0/16" ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "10.1.1.0/24"
            }
          }
        ]
      }
    },

    // ================= UBUNTU LOOP =================

    {
      "condition": "[greater(parameters('ubuntuVmCount'), 0)]",
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2023-04-01",
      "copy": { "name": "ubuntuPipLoop", "count": "[parameters('ubuntuVmCount')]" },
      "name": "[concat('Ubuntu-PIP-', copyIndex())]",
      "location": "[variables('location')]",
      "sku": { "name": "Standard" },
      "properties": { "publicIPAllocationMethod": "Static" }
    },

    {
      "condition": "[greater(parameters('ubuntuVmCount'), 0)]",
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-04-01",
      "copy": { "name": "ubuntuNicLoop", "count": "[parameters('ubuntuVmCount')]" },
      "name": "[concat('Ubuntu-NIC-', copyIndex())]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', concat('Ubuntu-PIP-', copyIndex()))]",
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]"
      ],
      "properties": {
        "networkSecurityGroup": {
          "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('ubuntuNsg'))]"
        },
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('subnetName'))]"
              },
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', concat('Ubuntu-PIP-', copyIndex()))]"
              }
            }
          }
        ]
      }
    },

    {
      "condition": "[greater(parameters('ubuntuVmCount'), 0)]",
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "copy": { "name": "ubuntuVmLoop", "count": "[parameters('ubuntuVmCount')]" },
      "name": "[concat('Ubuntu-VM-', copyIndex())]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', concat('Ubuntu-NIC-', copyIndex()))]"
      ],
      "properties": {
        "hardwareProfile": { "vmSize": "Standard_DC1s_v3" },
        "storageProfile": {
          "imageReference": {
            "publisher": "Canonical",
            "offer": "0001-com-ubuntu-server-jammy",
            "sku": "22_04-lts-gen2",
            "version": "latest"
          },
          "osDisk": { "createOption": "FromImage" }
        },
        "osProfile": {
          "computerName": "[concat('Ubuntu-VM-', copyIndex())]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]",
          "linuxConfiguration": {
            "disablePasswordAuthentication": false
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', concat('Ubuntu-NIC-', copyIndex()))]"
            }
          ]
        }
      }
    },

    {
      "condition": "[greater(parameters('ubuntuVmCount'), 0)]",
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "apiVersion": "2023-03-01",
      "copy": { "name": "ubuntuExtLoop", "count": "[parameters('ubuntuVmCount')]" },
      "name": "[concat('Ubuntu-VM-', copyIndex(), '/CustomScript')]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines', concat('Ubuntu-VM-', copyIndex()))]"
      ],
      "properties": {
        "publisher": "Microsoft.Azure.Extensions",
        "type": "CustomScript",
        "typeHandlerVersion": "2.1",
        "settings": {
          "fileUris": [ "[variables('ubuntuScriptUrl')]" ],
          "commandToExecute": "bash install-nginx.sh"
        }
      }
    },

    // ================= WINDOWS LOOP =================

    {
      "condition": "[greater(parameters('windowsVmCount'), 0)]",
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2023-04-01",
      "copy": { "name": "windowsPipLoop", "count": "[parameters('windowsVmCount')]" },
      "name": "[concat('Windows-PIP-', copyIndex())]",
      "location": "[variables('location')]",
      "sku": { "name": "Standard" },
      "properties": { "publicIPAllocationMethod": "Static" }
    },

    {
      "condition": "[greater(parameters('windowsVmCount'), 0)]",
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-04-01",
      "copy": { "name": "windowsNicLoop", "count": "[parameters('windowsVmCount')]" },
      "name": "[concat('Windows-NIC-', copyIndex())]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', concat('Windows-PIP-', copyIndex()))]",
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]"
      ],
      "properties": {
        "networkSecurityGroup": {
          "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('windowsNsg'))]"
        },
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('subnetName'))]"
              },
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', concat('Windows-PIP-', copyIndex()))]"
              }
            }
          }
        ]
      }
    },

    {
      "condition": "[greater(parameters('windowsVmCount'), 0)]",
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "copy": { "name": "windowsVmLoop", "count": "[parameters('windowsVmCount')]" },
      "name": "[concat('Windows-VM-', copyIndex())]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', concat('Windows-NIC-', copyIndex()))]"
      ],
      "properties": {
        "hardwareProfile": { "vmSize": "Standard_DC1s_v3" },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsDesktop",
            "offer": "windows-11",
            "sku": "win11-25h2-pro",
            "version": "latest"
          },
          "osDisk": { "createOption": "FromImage" }
        },
        "osProfile": {
          "computerName": "[concat('Windows-VM-', copyIndex())]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', concat('Windows-NIC-', copyIndex()))]"
            }
          ]
        }
      }
    },

    {
      "condition": "[greater(parameters('windowsVmCount'), 0)]",
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "apiVersion": "2023-03-01",
      "copy": { "name": "windowsExtLoop", "count": "[parameters('windowsVmCount')]" },
      "name": "[concat('Windows-VM-', copyIndex(), '/CustomScript')]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines', concat('Windows-VM-', copyIndex()))]"
      ],
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "CustomScriptExtension",
        "typeHandlerVersion": "1.10",
        "settings": {
          "fileUris": [ "[variables('windowsScriptUrl')]" ],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-iis.ps1"
        }
      }
    }

  ]
}
```

## Step-2: Add Parameters File

```json
{  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "14.0.0.0",
"adminPassword": {
    "value": "Azureuser@12"
    }
}
```

---

## Step-3: Deploy Windows VM

Set parameter:

```
"osType": "Windows"
```

Run:

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file day9-task2-template.json \
  --parameters day9-task2-parameters.json
```

---

## Step-4: Deploy Ubuntu VM

Change parameter:

```
"osType": "Ubuntu"
```

Deploy again using same template.

---

## Validation

| Selected OS    | Result             |
| -------------- | ------------------ |
| Windows        | Windows VM created |
| Ubuntu         | Linux VM created   |
| Template Reuse | Same file used     |

---