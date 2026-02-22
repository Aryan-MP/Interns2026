#  Day-14 

## Topic: Advanced Networking, DNS Resolution Flow, VPN Concepts & Azure Load Balancer Implementation

---

#  Deep Dive into Networking (Continuation from Day-12)

In earlier networking labs we understood:

* VNet / Subnets
* CIDR planning
* Public vs Private addressing

Today we go deeper into **how communication actually happens** across the internet and inside Azure.

---

#  What is DNS?

DNS (Domain Name System) translates human-friendly names into IP addresses.

```
www.google.com → 142.250.x.x
```

Without DNS, we would need to remember IP addresses for every website.

DNS works like a distributed hierarchical database.

---

#  DNS Hierarchy Structure

DNS is structured like a tree:

```
                (Root) .
                 |
        ---------------------
        |         |        |
       .com      .org     .net
        |
      google.com
        |
     www.google.com
```

Each level is responsible for answering a specific part of the query.

---

#  How DNS Resolution Works (Step-by-Step)

Let’s see what happens when you type:

```
www.google.com
```

---

## Step-1: Local Cache Check

Browser checks:

* Browser cache
* OS cache
* Hosts file

If not found → Query sent to DNS Resolver (ISP / Azure DNS).

---

## Step-2: Query Starts at Root Server (.)

The resolver asks:

```
"Where is .com?"
```

Root replies:

```
"I don’t know google.com, but ask .com TLD server."
```

---

## Step-3: Query to TLD Server (.com)

Resolver asks:

```
"Where is google.com?"
```

TLD replies:

```
"Ask Google's authoritative name server."
```

---

## Step-4: Query to Authoritative Name Server

Resolver asks:

```
"What is IP for www.google.com?"
```

Authoritative server responds with actual IP.

---

## Step-5: IP Returned to Client

Now browser connects directly to that IP.

---

#  Iterative vs Recursive Query

## Recursive Query

Client asks resolver:

```
Give me final answer.
```

Resolver does all work on behalf of client.

Used by:

* Browsers
* Applications

---

## Iterative Query

DNS server replies with best known information.

```
"I don't know final answer, but ask this server."
```

Used between DNS servers internally.

---

#  Common DNS Record Types

| Record   | Purpose                 |
| -------- | ----------------------- |
| A Record | Maps name → IPv4        |
| AAAA     | Maps name → IPv6        |
| CNAME    | Alias to another domain |
| MX       | Mail routing            |
| TXT      | Verification / Security |
| NS       | Name server delegation  |

---

#  What is a VPN?

VPN (Virtual Private Network) creates a secure encrypted tunnel between networks.

Used to:

* Connect on-premises to Azure
* Access private resources securely
* Hide traffic over internet

---

## How VPN Works

```
User → Encrypted Tunnel → Azure Gateway → Private Resources
```

Traffic is:

* Encrypted
* Authenticated
* Routed securely

Types:

* Site-to-Site VPN
* Point-to-Site VPN

---

#  Azure Traffic Distribution Services

Azure provides multiple services to manage traffic.

---

##  Azure Load Balancer

* Layer 4 (TCP/UDP)
* Distributes traffic inside region
* High performance
* No DNS routing

Used for:

* Internal scaling
* VM-based applications

---

## Azure Traffic Manager

* DNS-based routing
* Global load balancing
* Routes users to nearest region

Used for:

* Multi-region apps
* Disaster recovery

---

## Difference Between Them

| Feature  | Load Balancer | Traffic Manager |
| -------- | ------------- | --------------- |
| Layer    | L4            | DNS             |
| Scope    | Regional      | Global          |
| Routing  | IP-based      | DNS-based       |
| Use Case | VM scale      | Geo routing     |

---

#  Task: Implement Azure Load Balancer with Two VMs Using ARM Template

We will deploy:

* Virtual Network
* Two Backend VMs
* Load Balancer
* Health Probe
* Backend Pool
* Load Balancing Rule

---

#  Files Required

```
day14-lb-template.json
day14-lb-parameters.json
```

---

#  Add ARM Template Below

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",

  "parameters": {
    "loadBalancerName": {
      "type": "string"
    },
    "vmNamePrefix": {
      "type": "string"
    },
    "vmCount": {
      "type": "int"
    },
    "vmSize": {
      "type": "string"
    },
    "adminUsername": {
      "type": "string"
    },
    "adminPassword": {
      "type": "securestring"
    }
  },

  "variables": {
    "location": "[resourceGroup().location]",
    "vnetName": "myVnet",
    "subnetName": "mySubnet",
    "addressPrefix": "192.168.0.0/20",
    "subnetPrefix": "192.168.0.0/24",
    "nsgName": "web-nsg",
    "backendPoolName": "backendPool",
    "probeName": "httpProbe"
  },

  "resources": [


    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2025-05-01",
      "name": "[variables('nsgName')]",
      "location": "[variables('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "AllowHTTP",
            "properties": {
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "80",
              "access": "Allow",
              "priority": 100,
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          },
          {
            "name": "AllowSSH",
            "properties": {
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "22",
              "access": "Allow",
              "priority": 110,
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2025-05-01",
      "name": "[variables('vnetName')]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
    ],
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["[variables('addressPrefix')]"]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
              }
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2025-05-01",
      "name": "[concat(parameters('loadBalancerName'), '-pip')]",
      "location": "[variables('location')]",
      "sku": { 
        "name": "Standard" 
    },
      "properties": { 
        "publicIPAllocationMethod": "Static" 
    }
    },
    {
      "type": "Microsoft.Network/loadBalancers",
      "apiVersion": "2025-05-01",
      "name": "[parameters('loadBalancerName')]",
      "location": "[variables('location')]",
      "dependsOn": ["[resourceId('Microsoft.Network/publicIPAddresses', concat(parameters('loadBalancerName'), '-pip'))]"],
      "sku": { "name": "Standard" },
      "properties": {
        "frontendIPConfigurations": [
          {
            "name": "frontend",
            "properties": {
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', concat(parameters('loadBalancerName'), '-pip'))]"
              }
            }
          }
        ],
        "backendAddressPools": [
          { "name": "[variables('backendPoolName')]" }
        ],
        "probes": [
          {
            "name": "[variables('probeName')]",
            "properties": {
              "protocol": "Tcp",
              "port": 80,
              "intervalInSeconds": 15,
              "numberOfProbes": 2
            }
          }
        ],
        "loadBalancingRules": [
          {
            "name": "httpRule",
            "properties": {
              "frontendIPConfiguration": {
                "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', parameters('loadBalancerName'), 'frontend')]"
              },
              "backendAddressPool": {
                "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', parameters('loadBalancerName'), variables('backendPoolName'))]"
              },
              "probe": {
                "id": "[resourceId('Microsoft.Network/loadBalancers/probes', parameters('loadBalancerName'), variables('probeName'))]"
              },
              "protocol": "Tcp",
              "frontendPort": 80,
              "backendPort": 80
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2025-05-01",
      "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '-pip')]",
      "location": "[variables('location')]",
      "copy": { 
        "name": "pipLoop", 
        "count": "[parameters('vmCount')]" 
    },
      "sku": { 
        "name": "Standard" 
    },
      "properties": {
        "publicIPAllocationMethod": "Static" 
        }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2025-05-01",
      "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '-nic')]",
      "location": "[variables('location')]",
      "copy": { 
        "name": "nicLoop", 
        "count": "[parameters('vmCount')]" 
    },
      "dependsOn": [
        "pipLoop", 
        "[resourceId('Microsoft.Network/loadBalancers', parameters('loadBalancerName'))]"
    ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), variables('subnetName'))]"
              },
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', concat(parameters('vmNamePrefix'), copyIndex(), '-pip'))]"
              },
              "loadBalancerBackendAddressPools": [
                {
                  "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', parameters('loadBalancerName'), variables('backendPoolName'))]"
                }
              ]
            }
          }
        ]
      }
    },

    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2023-03-01",
      "name": "[concat(parameters('vmNamePrefix'), copyIndex())]",
      "location": "[variables('location')]",
      "copy": { 
        "name": "vmLoop", 
        "count": "[parameters('vmCount')]" 
    },
      "dependsOn": [
        "nicLoop"
    ],
      "properties": {
        "hardwareProfile": { "vmSize": "[parameters('vmSize')]" },
        "osProfile": {
          "computerName": "[concat(parameters('vmNamePrefix'), copyIndex())]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "Canonical",
            "offer": "0001-com-ubuntu-server-jammy",
            "sku": "22_04-lts-gen2",
            "version": "latest"
          },
          "osDisk": { "createOption": "FromImage" }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmNamePrefix'), copyIndex(), '-nic'))]"
            }
          ]
        }
      }
    },
    {
        "type": "microsoft.Compute/virtualMachines/extensions",
        "apiVersion": "2023-03-01",
        "name": "[concat(parameters('vmNamePrefix'), copyIndex(), '/install-nginx')]",
        "location": "[variables('location')]",
        "copy": { 
          "name": "extensionLoop", 
          "count": "[parameters('vmCount')]"
    },
        "dependsOn": [
          "vmLoop"
      ],
        "properties": {
          "publisher": "Microsoft.Azure.Extensions",
          "type": "CustomScript",
          "typeHandlerVersion": "2.1",
          "autoUpgradeMinorVersion": true,
          "settings": {
            "commandToExecute": "[concat('apt-get update && apt-get install -y nginx && echo VM-', copyIndex(), ' > /var/www/html/index.html')]"
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
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",

    "loadBalancerName":{
        "value": "myLoadBalancer"
    },
    "vmNamePrefix": {
        "value": "myvm"
    },
    "vmCount": {
        "value": 2
    },
    "vmSize": {
        "value": "Standard_DC1s_v3"
    },
    "adminUsername": {
        "value": "azureuser"
    },
    "adminPassword": {
        "value": "Azureuser@12"
    }
}
```

---

# Deploy the Template

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file day14-lb-template.json \
  --parameters day14-lb-parameters.json
```

---

#  Validation Steps

After deployment:

1️ Get Load Balancer Public IP
2️ Open Browser:

```
http://<LoadBalancer-IP>
```

3️⃣ Refresh multiple times.

Traffic will alternate between VM1 and VM2.

---

#  What Happens Internally

```
Client Request
     ↓
Azure Load Balancer
     ↓
Health Probe Checks VM Status
     ↓
Distributes Request to Healthy VM
```

---