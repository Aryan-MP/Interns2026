# Task-1 
## Reverse Proxy - Create a Vnet and a Private Subnet with a VM in it and add a HTML file to the VM and don't allow public access to it but i should be able to access it.


{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": {
      "type": "string"
    },
    "adminPassword": {
      "type": "secureString"
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    }
  },
  "variables": {
    "vnetName": "secureVnet",
    "jumpSubnet": "public-subnet",
    "privateSubnet": "private-subnet",
    "jumpVMName": "jumpVM",
    "webVMName": "webVM",
    "jumpNic": "jumpNic",
    "webNic": "webNic",
    "publicIpName": "jumpPublicIP",
    "jumpNSG": "jumpNSG",
    "webNSG": "webNSG"
  },
  "resources": [

    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-05-01",
      "name": "[variables('jumpNSG')]",
      "location": "[parameters('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-RDP-Internet",
            "properties": {
              "priority": 100,
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
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2023-05-01",
      "name": "[variables('webNSG')]",
      "location": "[parameters('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "Allow-HTTP-VNet",
            "properties": {
              "priority": 100,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "VirtualNetwork",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "80"
            }
          },
          {
            "name": "Allow-RDP-From-Jump",
            "properties": {
              "priority": 110,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "10.0.1.0/24",
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
      "apiVersion": "2023-05-01",
      "name": "[variables('vnetName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["10.0.0.0/16"]
        },
        "subnets": [
          {
            "name": "[variables('jumpSubnet')]",
            "properties": {
              "addressPrefix": "10.0.1.0/24",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('jumpNSG'))]"
              }
            }
          },
          {
            "name": "[variables('privateSubnet')]",
            "properties": {
              "addressPrefix": "10.0.2.0/24",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('webNSG'))]"
              }
            }
          }
        ]
      }
    },

    {
  "type": "Microsoft.Network/publicIPAddresses",
  "apiVersion": "2023-05-01",
  "name": "[variables('publicIpName')]",
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
      "apiVersion": "2023-05-01",
      "name": "[variables('jumpNic')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]",
        "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIpName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('jumpSubnet'))]"
              },
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIpName'))]"
              }
            }
          }
        ]
      }
    },

    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2023-05-01",
      "name": "[variables('webNic')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('privateSubnet'))]"
              }
            }
          }
        ]
      }
    },

    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[variables('jumpVMName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('jumpNic'))]"
      ],
      "properties": {
        "hardwareProfile": { "vmSize": "Standard_L2aos_v4" },
        "osProfile": {
          "computerName": "jumpVM",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "2022-Datacenter-g2",
            "version": "latest"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('jumpNic'))]"
            }
          ]
        }
      }
    },

    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[variables('webVMName')]",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('webNic'))]"
      ],
      "properties": {
        "hardwareProfile": { "vmSize": "Standard_L2aos_v4" },
        "osProfile": {
          "computerName": "webVM",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "2022-Datacenter-g2",
            "version": "latest"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('webNic'))]"
            }
          ]
        }
      }
    },

    {
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "apiVersion": "2023-03-01",
  "name": "[concat(variables('webVMName'), '/IISInstall')]",
  "location": "[parameters('location')]",
  "dependsOn": [
    "[resourceId('Microsoft.Compute/virtualMachines', variables('webVMName'))]"
  ],
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "CustomScriptExtension",
    "typeHandlerVersion": "1.10",
    "autoUpgradeMinorVersion": true,
    "settings": {
      "commandToExecute": "powershell -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Start-Sleep -Seconds 20; New-Item -Path 'C:\\inetpub\\wwwroot\\index.html' -ItemType File -Force; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<h1>Private Secure VM Web Page</h1>'\""
    }
  }
}

  ]
}
