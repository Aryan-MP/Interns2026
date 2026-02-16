 Nested Virtualization in Azure - Solution Summary

## Objective
Create an Azure Windows VM with Hyper-V that runs a nested Linux VM inside it. The Linux VM creates an `index.html` file shared with the Windows host via SMB.

## Architecture

```
Azure Cloud
└── Windows Server 2022 VM (Host)
    ├── Hyper-V Hypervisor
    ├── Internal Virtual Switch (192.168.100.0/24)
    ├── SMB Share: C:\SharedFiles
    └── Nested Linux VM (Ubuntu 22.04)
        └── Mounts: //192.168.100.1/SharedFiles → /mnt/shared
        └── Creates: index.html
```

### Technical Implementation

**1. Infrastructure Setup**
- Windows Server 2022 VM with nested virtualization support (Standard_D4s_v3 or E series)
- Standard SKU public IP (Basic SKU has regional limits)
- Virtual network with RDP-enabled NSG
- Single CustomScriptExtension to avoid conflicts

**2. Hyper-V Configuration**
- Install Hyper-V feature with management tools
- Create Internal Virtual Switch (isolated from external network)
- Configure Windows host with static IP: 192.168.100.1/24
- Scheduled task handles automatic continuation after reboot

**3. File Sharing Setup**
- Create SMB share at `C:\SharedFiles` on Windows host
- Set open access (guest authentication) - secure because network is isolated
- Configure firewall rules for SMB on private profile only
- NTFS permissions set to Everyone/FullControl

**4. Nested Linux VM Deployment**
- Download Ubuntu 22.04 cloud image from Canonical
- Convert .img to .vhdx format
- Resize disk to 20GB for adequate space
- Create cloud-init ISO with user-data and meta-data

**5. Cloud-Init Automation**
- Install cifs-utils package for SMB mounting
- Mount Windows share at `/mnt/shared`
- Created styled HTML file with system information
- Add mount to `/etc/fstab` for persistence

**6. Network Isolation**
- Linux VM only accessible through Windows host
- No direct external connectivity to nested VM
- Uses Hyper-V Internal Switch (host-guest only)


## Setting up Storage Account
```bash
STORAGE_NAME="scripts$(date +%s)"
az storage account create --name $STORAGE_NAME --resource-group  --location  --sku Standard_LRS --allow-blob-public-access true
az storage container create --name scripts --account-name $STORAGE_NAME --public-access blob
az storage blob upload --account-name $STORAGE_NAME --container-name scripts --name ConfigureVM.ps1 --file ConfigureVM.ps1

New-AzResourceGroupDeployment `
    -Name NestedVmDeployment `
    -ResourceGroupName $rgName `
    -TemplateFile fullvm.json `
    -TemplateParameterFile parameters.json
```

