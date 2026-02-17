**Topic:** Using **Bicep** for Deployment + Secure Access to Private VM via Public VM (Port Forwarding)

---

#  Task-1

## Create a Storage Account Using Bicep Template and Execute It

---

##  Objective

Learn how to:

* Write infrastructure using **Bicep**
* Deploy resources using Azure CLI
* Understand how Bicep simplifies ARM JSON

---

##  File to Create

Create a file named:

```
storage.bicep
```

---

##  Add the Following Code

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

## ▶ Deploy the Bicep Template

Login to Azure:

```bash
az login
```

Run Deployment:

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file storage.bicep \
  --parameters storageAccountName=<UNIQUE_STORAGE_NAME>
```

---

##  Validation

Go to Azure Portal → Resource Group → Verify Storage Account Created.

---

#  Task-2

## Create VNet with Public & Private Subnets and Deploy VMs

---

##  Objective

Build a secure architecture:

* Public Subnet → Jump VM (Gateway)
* Private Subnet → Application VM
* Install application in Private VM
* Access it **through Public VM only**
* Implement **Port Forwarding**

---

##  Architecture Flow

```
Your Laptop
    ↓
Public VM (Jump Host)
    ↓ Port Forwarding
Private VM (Application Server)
```

Private VM is **not exposed to Internet**.

---

## Create File

```
day10-network-vm.bicep
```

---

## ✍️ Add Template Code

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
        },
        {
            "type": "Microsoft.Network/publicIPAddresses",
            "apiVersion": "2020-06-01",
            "name": "[variables('publicIPName')]",
            "location": "[parameters('location')]",
            "sku": {
                "name": "Standard"
            },
            "properties": {
                "publicIPAllocationMethod": "Static"
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2020-06-01",
            "name": "[variables('vnetName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
            ],
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.0.0.0/16"
                    ]
                },
                "subnets": [
                    {
                        "name": "[variables('publicSubnetName')]",
                        "properties": {
                            "addressPrefix": "10.0.1.0/24",
                            "networkSecurityGroup": {
                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
                            }
                        }
                    },
                    {
                        "name": "[variables('privateSubnetName')]",
                        "properties": {
                            "addressPrefix": "10.0.2.0/24",
                            "networkSecurityGroup": {
                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
                            }
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2020-06-01",
            "name": "nic-public",
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
                            "privateIPAllocationMethod": "Dynamic",
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))]"
                            },
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('publicSubnetName'))]"
                            }
                        }
                    }
                ],
                "enableIPForwarding": true
            }
        },
        {
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2020-06-01",
            "name": "nic-private",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]"
            ],
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAllocationMethod": "Static",
                            "privateIPAddress": "[variables('privateVmIP')]",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('privateSubnetName'))]"
                            }
                        }
                    }
                ]
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2020-06-01",
            "name": "[variables('publicVmName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/networkInterfaces', 'nic-public')]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[parameters('vmSize')]"
                },
                "osProfile": {
                    "computerName": "gatewayvm",
                    "adminUsername": "[parameters('adminUsername')]",
                    "adminPassword": "[parameters('adminPassword')]",
                    "linuxConfiguration": {
                        "disablePasswordAuthentication": false
                    }
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "Canonical",
                        "offer": "0001-com-ubuntu-server-jammy",
                        "sku": "22_04-lts-gen2",
                        "version": "latest"
                    },
                    "osDisk": {
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', 'nic-public')]"
                        }
                    ]
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2020-06-01",
            "name": "[variables('privateVmName')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/networkInterfaces', 'nic-private')]"
            ],
            "properties": {
                "hardwareProfile": {
                    "vmSize": "[parameters('vmSize')]"
                },
                "osProfile": {
                    "computerName": "webservervm",
                    "adminUsername": "[parameters('adminUsername')]",
                    "adminPassword": "[parameters('adminPassword')]",
                    "linuxConfiguration": {
                        "disablePasswordAuthentication": false
                    }
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "Canonical",
                        "offer": "0001-com-ubuntu-server-jammy",
                        "sku": "22_04-lts-gen2",
                        "version": "latest"
                    },
                    "osDisk": {
                        "createOption": "FromImage"
                    }
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', 'nic-private')]"
                        }
                    ]
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-07-01",
            "name": "[concat(variables('privateVmName'), '/setup-webserver')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Compute/virtualMachines', variables('privateVmName'))]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Extensions",
                "type": "CustomScript",
                "typeHandlerVersion": "2.1",
                "autoUpgradeMinorVersion": true,
                "settings": {},
                "protectedSettings": {
                    "commandToExecute": "apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx && cat > /var/www/html/index.html <<'EOF'\n<!DOCTYPE html>\n<html>\n<head>\n<title>Private VM Web Server</title>\n<style>\nbody { font-family: Arial; background: linear-gradient(135deg, #667eea, #764ba2); color: white; text-align: center; padding: 50px; }\nh1 { font-size: 3em; }\n.highlight { color: #ffd700; font-weight: bold; }\n</style>\n</head>\n<body>\n<h1>Port Forwarding Success!</h1>\n<p>This page is served from the <span class=\"highlight\">Private VM</span></p>\n<p>Accessed via <span class=\"highlight\">iptables port forwarding</span></p>\n<p>Private IP: <span class=\"highlight\">10.0.2.10</span></p>\n</body>\n</html>\nEOF\nsystemctl enable nginx && systemctl start nginx"
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines/extensions",
            "apiVersion": "2019-07-01",
            "name": "[concat(variables('publicVmName'), '/setup-portforward')]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Compute/virtualMachines', variables('publicVmName'))]",
                "[resourceId('Microsoft.Compute/virtualMachines/extensions', variables('privateVmName'), 'setup-webserver')]"
            ],
            "properties": {
                "publisher": "Microsoft.Azure.Extensions",
                "type": "CustomScript",
                "typeHandlerVersion": "2.1",
                "autoUpgradeMinorVersion": true,
                "settings": {},
                "protectedSettings": {
                    "commandToExecute": "echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf && sysctl -p && iptables -F && iptables -t nat -F && iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.2.10:80 && iptables -t nat -A POSTROUTING -j MASQUERADE && mkdir -p /etc/iptables && iptables-save > /etc/iptables/rules.v4 && cat > /etc/systemd/system/iptables-restore.service <<'EOF'\n[Unit]\nDescription=Restore iptables rules\nBefore=network-pre.target\n[Service]\nType=oneshot\nExecStart=/sbin/iptables-restore /etc/iptables/rules.v4\n[Install]\nWantedBy=multi-user.target\nEOF\nsystemctl daemon-reload && systemctl enable iptables-restore.service && echo 'Port forwarding setup complete!'"
                }
            }
        }
    ],
    "outputs": {
        "publicIP": {
            "type": "String",
            "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))).ipAddress]"
        },
        "sshCommand": {
            "type": "String",
            "value": "[concat('ssh ', parameters('adminUsername'), '@', reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))).ipAddress)]"
        },
        "webUrl": {
            "type": "String",
            "value": "[concat('http://', reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))).ipAddress)]"
        }
    }
}

---

##  Deploy the Environment

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file day10-network-vm.bicep \
  --parameters adminUsername=azureuser adminPassword=<PASSWORD>
```

---

#  Configure Application in Private VM

Login to **Public VM** using RDP.

From Public VM connect to Private VM:

```bash
ssh azureuser@10.10.2.4
```

Install Web Server:

```bash
sudo apt update
sudo apt install nginx -y
```

Check:

```bash
curl localhost
```

---

#  Configure Port Forwarding (On Public VM)

Open **PowerShell as Administrator** in Public VM.

Run:

```powershell
netsh interface portproxy add v4tov4 `
listenport=8080 listenaddress=0.0.0.0 `
connectport=80 connectaddress=10.10.2.4
```

Allow firewall:

```powershell
New-NetFirewallRule -DisplayName "Allow8080" `
Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
```

---

#  Access Application from Your Laptop

Open browser:

```
http://<Public-VM-IP>:8080
```

---

## What Happens Internally

```
Request hits Public VM :8080
↓
Public VM forwards traffic to Private VM :80
↓
Private VM serves nginx page
```

Private VM never exposed publicly. This is a **secure jump-host pattern** used in real enterprises.

---

#  Validation Checklist

| Component       | Status                 |
| --------------- | ---------------------- |
| Storage Account | Created via Bicep      |
| VNet            | Created                |
| Public VM       | Accessible             |
| Private VM      | No Public IP           |
| Application     | Installed              |
| Port Forwarding | Working                |
| Access          | Through Public VM Only |

---