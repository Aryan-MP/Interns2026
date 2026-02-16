# Azure VNet Infrastructure with Public and Private Subnets

This ARM template deploys a complete Azure infrastructure with:
- Virtual Network with Public and Private subnets
- Public VM with Nginx reverse proxy (accessible from internet)
- Private VM with Nginx web server (no public IP, accessible only through public VM)
- Network Security Groups with proper security rules
- Automatic configuration via cloud-init scripts

## Architecture Diagram

```
Internet
    ↓
[Public IP] → [Public Subnet - 10.0.1.0/24]
                     ↓
              [Public VM - Nginx Reverse Proxy]
                     ↓
              [Private Subnet - 10.0.2.0/24]
                     ↓
              [Private VM - Nginx Web Server]
                     ↓
              [Your Website]
```

## Features

✅ **Fully Automated Deployment** - One-click deployment with ARM template  
✅ **Secure Architecture** - Private VM has no internet access  
✅ **Reverse Proxy** - Public VM forwards traffic to private VM  
✅ **Network Security Groups** - Properly configured firewall rules  
✅ **Custom Scripts** - Automatic Nginx installation and configuration  
✅ **SSH Key or Password** - Flexible authentication options  
✅ **Production Ready** - Standard SKU, Premium SSD, auto-scaling ready

## Prerequisites

- Azure subscription
- Azure CLI or PowerShell installed
- SSH key pair (for SSH authentication) or password

## Quick Start

### Option 1: Using Azure CLI (Linux/Mac/WSL)

1. **Make the script executable:**
```bash
chmod +x deploy.sh
```

2. **Run the deployment:**
```bash
./deploy.sh
```

3. **Follow the prompts** to enter:
   - Resource group name
   - Location
   - Admin username
   - Authentication method (SSH key or password)
   - Your public IP (for SSH access restriction)

### Option 2: Using PowerShell (Windows)

1. **Run the deployment:**
```powershell
.\deploy.ps1
```

2. **Follow the prompts** to enter the required parameters

### Option 3: Manual Deployment with Azure CLI

```bash
# Login to Azure
az login

# Create resource group
az group create --name MyWebAppResourceGroup --location eastus

# Deploy template
az deployment group create \
  --name vnet-deployment \
  --resource-group MyWebAppResourceGroup \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

### Option 4: Manual Deployment with PowerShell

```powershell
# Login to Azure
Connect-AzAccount

# Create resource group
New-AzResourceGroup -Name MyWebAppResourceGroup -Location eastus

# Deploy template
New-AzResourceGroupDeployment `
  -Name vnet-deployment `
  -ResourceGroupName MyWebAppResourceGroup `
  -TemplateFile .\azuredeploy.json `
  -TemplateParameterFile .\azuredeploy.parameters.json
```

### Option 5: Deploy via Azure Portal

1. Click the button below to deploy directly from Azure Portal:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fyour-repo%2Fazuredeploy.json)

2. Fill in the required parameters
3. Click "Review + Create"
4. Click "Create"

## Parameters

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `location` | Azure region | Resource group location | No |
| `vnetName` | Virtual Network name | MyVNet | No |
| `vnetAddressPrefix` | VNet address space | 10.0.0.0/16 | No |
| `publicSubnetName` | Public subnet name | PublicSubnet | No |
| `publicSubnetPrefix` | Public subnet CIDR | 10.0.1.0/24 | No |
| `privateSubnetName` | Private subnet name | PrivateSubnet | No |
| `privateSubnetPrefix` | Private subnet CIDR | 10.0.2.0/24 | No |
| `publicVmName` | Public VM name | PublicVM | No |
| `privateVmName` | Private VM name | PrivateVM | No |
| `vmSize` | VM size | Standard_B2s | No |
| `adminUsername` | Admin username | azureuser | No |
| `authenticationType` | SSH key or password | sshPublicKey | No |
| `adminPasswordOrKey` | SSH public key or password | - | **Yes** |
| `allowedSourceIP` | IP allowed for SSH (x.x.x.x/32 or *) | * | No |
| `ubuntuOSVersion` | Ubuntu version | Ubuntu-2204 | No |

## Post-Deployment

After successful deployment, you'll receive:

1. **Public VM IP Address** - Use this to access the website
2. **Public VM FQDN** - DNS name for the public VM
3. **Private VM IP** - Internal IP of the web server
4. **Website URL** - Direct link to your website
5. **SSH Command** - Command to SSH into the public VM

### Access Your Website

```bash
# Using the public IP
http://<PUBLIC_VM_IP>

# Using the FQDN
http://<PUBLIC_VM_FQDN>
```

### SSH Access

**To Public VM:**
```bash
ssh azureuser@<PUBLIC_VM_IP>
```

**To Private VM (from Public VM):**
```bash
# First SSH to public VM
ssh azureuser@<PUBLIC_VM_IP>

# Then SSH to private VM
ssh azureuser@10.0.2.4
```

## Network Security

### Public Subnet NSG Rules

| Priority | Name | Port | Source | Destination | Action |
|----------|------|------|--------|-------------|--------|
| 100 | Allow-HTTP | 80 | Internet | * | Allow |
| 110 | Allow-HTTPS | 443 | Internet | * | Allow |
| 120 | Allow-SSH | 22 | Your IP | * | Allow |

### Private Subnet NSG Rules

| Priority | Name | Port | Source | Destination | Action |
|----------|------|------|--------|-------------|--------|
| 100 | Allow-HTTP-From-Public | 80,443 | 10.0.1.0/24 | * | Allow |
| 110 | Allow-SSH-From-Public | 22 | 10.0.1.0/24 | * | Allow |
| 200 | Deny-All-Inbound | * | * | * | Deny |

## Customization

### Modify the Website

SSH to the private VM and edit the HTML file:
```bash
sudo nano /var/www/html/index.html
```

### Change Nginx Configuration

**On Public VM (Reverse Proxy):**
```bash
sudo nano /etc/nginx/sites-available/reverse-proxy
sudo nginx -t
sudo systemctl reload nginx
```

**On Private VM (Web Server):**
```bash
sudo nano /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl reload nginx
```

### Add SSL/TLS

Install Let's Encrypt on the public VM:
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

## Monitoring and Diagnostics

### Check VM Status
```bash
az vm list -g MyWebAppResourceGroup -o table
```

### View NSG Rules
```bash
az network nsg show -g MyWebAppResourceGroup -n PublicSubnet-NSG
```

### Check Nginx Status
```bash
# On any VM
sudo systemctl status nginx
sudo nginx -t
```

### View Logs
```bash
# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Cloud-init logs
sudo cat /var/log/cloud-init-output.log
```

## Troubleshooting

### Website Not Accessible

1. **Check if VMs are running:**
```bash
az vm list -g MyWebAppResourceGroup --query "[].{Name:name, PowerState:powerState}" -o table
```

2. **Check Nginx status on both VMs:**
```bash
sudo systemctl status nginx
```

3. **Check cloud-init logs:**
```bash
sudo cat /var/log/cloud-init-output.log
```

4. **Test connectivity from Public VM to Private VM:**
```bash
curl http://10.0.2.4
```

### SSH Connection Issues

1. **Verify NSG rules:**
```bash
az network nsg rule list -g MyWebAppResourceGroup --nsg-name PublicSubnet-NSG -o table
```

2. **Check your source IP:**
```bash
curl ifconfig.me
```

3. **Update NSG rule with your current IP:**
```bash
az network nsg rule update \
  --resource-group MyWebAppResourceGroup \
  --nsg-name PublicSubnet-NSG \
  --name Allow-SSH \
  --source-address-prefixes "YOUR_IP/32"
```

## Cost Estimation

Approximate monthly costs (East US region):

- 2x Standard_B2s VMs: ~$60/month
- 2x Premium SSD (128 GB): ~$20/month
- 1x Static Public IP: ~$4/month
- Network egress (estimated): ~$10/month

**Total: ~$94/month**

*Costs may vary by region and usage. Use [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) for accurate estimates.*

## Cleanup

To delete all resources and stop incurring costs:

**Azure CLI:**
```bash
az group delete --name MyWebAppResourceGroup --yes --no-wait
```

**PowerShell:**
```powershell
Remove-AzResourceGroup -Name MyWebAppResourceGroup -Force
```

## Production Recommendations

For production environments, consider:

1. **Azure Application Gateway** - Replace VM-based reverse proxy
2. **Azure Bastion** - Replace jump host for secure SSH access
3. **Azure Key Vault** - Store SSH keys and secrets
4. **Azure Monitor** - Enable logging and alerts
5. **Azure Backup** - Enable VM backups
6. **DDoS Protection** - Enable Standard tier
7. **Web Application Firewall** - Add WAF rules
8. **Auto-scaling** - Configure VM scale sets
9. **Load Balancer** - Add for high availability
10. **Azure Front Door** - Add CDN and global load balancing

## Security Best Practices

✅ Use SSH keys instead of passwords  
✅ Restrict SSH access to specific IP addresses  
✅ Enable Azure Security Center  
✅ Enable Just-In-Time (JIT) VM access  
✅ Regularly update and patch VMs  
✅ Use Azure Policy for compliance  
✅ Enable Azure Monitor and Log Analytics  
✅ Implement Azure Sentinel for SIEM  
✅ Use managed identities where possible  
✅ Enable disk encryption

## Support

For issues or questions:
- Review Azure documentation: https://docs.microsoft.com/azure
- Check deployment logs in Azure Portal
- Review NSG flow logs
- Enable diagnostics on VMs

## License

This template is provided as-is under the MIT License.

## Version History

- **v1.0.0** - Initial release with basic VNet, subnets, and VMs
