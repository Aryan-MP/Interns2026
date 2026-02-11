# Azure ARM Deployment & VM Disk Extension — Task Summary

## Task 1 — Infrastructure Provisioning Using ARM Templates

**Objective:** Provision a Windows VM environment using an ARM template with networking, storage, security rules, and optional Custom Script Extension.

### Scope
- Deployed resources via ARM template (IaC approach)
- Created VM, VNet, Subnet, NSG, Public IP, NIC, Storage Account
- Used parameterized template for reusability and environment flexibility
- Executed Custom Script Extension to install IIS + Chrome
- Used incremental deployments for safe updates

### Key Concepts Applied
- Parameterized ARM templates with defaults + override parameters file
- Conditional resource deployment (feature flags)
- Managed identity vs key-based storage auth (data plane vs control plane)
- Extension-based post-provision configuration

### Core Deployment Commands (Generic Reference)

```bash
# Deploy ARM template
az deployment group create \
  --resource-group <rg-name> \
  --template-file azuredeploy.json \
  --parameters azuredeploy.parameters.json

# List deployed VMs
az vm list -g <rg-name> -o table

# Show VM public IP
az vm show -d \
  --resource-group <rg-name> \
  --name <vm-name> \
  --query publicIps -o tsv

# Check deployment status
az deployment group show \
  --resource-group <rg-name> \
  --name <deployment-name> \
  --query properties.provisioningState

```

## Task 2 — Attach Additional Managed Data Disk to Existing VM (ARM Template)

**Objective:** Extend VM storage by adding one managed data disk through an ARM template update using incremental deployment.

### Steps
- Added managed disk resource block in ARM template
- Attached disk via VM `storageProfile.dataDisks` section
- Used fixed disk name / condition flag to prevent duplicate disks on redeploy
- Redeployed template in incremental mode (no VM recreation)
- Verified attachment using Azure CLI
- Initialized and formatted disk inside the VM

```bash
# Verify attached data disks
az vm show \
  --resource-group <rg-name> \
  --name <vm-name> \
  --query "storageProfile.dataDisks" -o table

# List managed disks
az disk list -g <rg-name> -o table

# Detach a disk (if needed)
az vm disk detach \
  --resource-group <rg-name> \
  --vm-name <vm-name> \
  --name <disk-name>

```