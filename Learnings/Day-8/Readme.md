Azure ARM Templates – Deployment Steps

This project shows how to create and deploy Azure resources using ARM Templates.

Prerequisites

Azure Subscription

Azure CLI Installed

Login to Azure

az login
az group create --name MyResourceGroup --location eastus

Task 1: Create VM with IIS Installation
Steps

Create an ARM template file vm-iis.json.

Add resource type: Microsoft.Compute/virtualMachines.

Add Custom Script Extension to install IIS.

Use PowerShell command inside template:

Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Deploy
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file vm-iis.json


After deployment, open browser:

http://<Public-IP>

Task 2: Create VM with Data Disk
Steps

Create vm-datadisk.json.

Inside storageProfile, add:

"dataDisks": [
  {
    "lun": 0,
    "createOption": "Empty",
    "diskSizeGB": 10
  }
]

Deploy
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file vm-datadisk.json

Task 3: Create Azure Container Registry (ACR)
Steps

Create acr.json.

Add resource type: Microsoft.ContainerRegistry/registries.

Deploy
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file acr.json


Login to ACR:

az acr login --name <acr-name>

Task 4: Create Azure Container Instance (ACI)
Steps

Create aci.json.

Add resource type: Microsoft.ContainerInstance/containerGroups.

Provide container image (example: nginx).

Deploy
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file aci.json


Get Container IP:

az container show \
  --resource-group MyResourceGroup \
  --name <container-name> \
  --query ipAddress.ip \
  --output table
