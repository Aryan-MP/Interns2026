# Quick Start Guide

## 🚀 Deploy in 5 Minutes

### Step 1: Choose Your Method

**Linux/Mac/WSL Users:**
```bash
chmod +x deploy.sh
./deploy.sh
```

**Windows PowerShell Users:**
```powershell
.\deploy.ps1
```

**Azure Portal Users:**
- Upload `azuredeploy.json` to Azure Portal
- Create Custom Deployment
- Fill parameters and deploy

### Step 2: Generate SSH Key (If Needed)

**Linux/Mac:**
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub  # Copy this key
```

**Windows:**
```powershell
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub  # Copy this key
```

### Step 3: Get Your Public IP (Optional but Recommended)

**Find your public IP:**
```bash
curl ifconfig.me
```

Or visit: https://whatismyipaddress.com/

### Step 4: Deploy

Run the deployment script and provide:
1. Resource Group Name (default: MyWebAppResourceGroup)
2. Location (default: eastus)
3. Admin Username (default: azureuser)
4. Authentication: Choose SSH key or password
5. Your public IP for SSH access

### Step 5: Access Your Website

After deployment (5-10 minutes), you'll get:
```
Website URL: http://x.x.x.x
SSH Command: ssh azureuser@x.x.x.x
```

Open the URL in your browser! 🎉

## 📋 Pre-filled Commands

### Fastest Deployment (Using Defaults)

Edit `azuredeploy.parameters.json` with your SSH key, then:

```bash
# Azure CLI
az group create --name MyWebAppResourceGroup --location eastus
az deployment group create \
  --name vnet-deployment \
  --resource-group MyWebAppResourceGroup \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

```powershell
# PowerShell
New-AzResourceGroup -Name MyWebAppResourceGroup -Location eastus
New-AzResourceGroupDeployment `
  -Name vnet-deployment `
  -ResourceGroupName MyWebAppResourceGroup `
  -TemplateFile .\azuredeploy.json `
  -TemplateParameterFile .\azuredeploy.parameters.json
```

## ⚡ One-Liner Deployment (Advanced)

Replace `YOUR_SSH_KEY` with your actual SSH public key:

```bash
az group create --name MyWebAppRG --location eastus && \
az deployment group create \
  --name vnet-deploy \
  --resource-group MyWebAppRG \
  --template-file azuredeploy.json \
  --parameters \
    adminUsername=azureuser \
    authenticationType=sshPublicKey \
    adminPasswordOrKey="YOUR_SSH_KEY"
```

## 🧪 Testing After Deployment

### 1. Test Website Accessibility
```bash
curl http://<PUBLIC_VM_IP>
```

### 2. SSH to Public VM
```bash
ssh azureuser@<PUBLIC_VM_IP>
```

### 3. From Public VM, Test Private VM
```bash
# Inside Public VM
curl http://10.0.2.4
ssh azureuser@10.0.2.4
```

### 4. Check Nginx Status
```bash
# On Public VM
sudo systemctl status nginx
curl http://10.0.2.4

# On Private VM (SSH from Public VM first)
sudo systemctl status nginx
```

## 🛠️ Common Customizations

### Change Website Content

```bash
# SSH to Private VM via Public VM
ssh azureuser@<PUBLIC_IP>
ssh azureuser@10.0.2.4

# Edit website
sudo nano /var/www/html/index.html
```

### Restrict SSH to Your IP Only

```bash
# Get your IP
MY_IP=$(curl -s ifconfig.me)

# Update NSG rule
az network nsg rule update \
  --resource-group MyWebAppResourceGroup \
  --nsg-name PublicSubnet-NSG \
  --name Allow-SSH \
  --source-address-prefixes "$MY_IP/32"
```

### Add SSL Certificate

```bash
# On Public VM
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yourdomain.com
```

## 🧹 Cleanup

```bash
# Delete everything
az group delete --name MyWebAppResourceGroup --yes --no-wait
```

## 📊 What Gets Deployed

```
MyWebAppResourceGroup/
├── MyVNet (10.0.0.0/16)
│   ├── PublicSubnet (10.0.1.0/24)
│   │   └── PublicVM (Reverse Proxy)
│   │       ├── Public IP
│   │       └── Nginx
│   └── PrivateSubnet (10.0.2.0/24)
│       └── PrivateVM (Web Server)
│           ├── No Public IP
│           └── Nginx
├── PublicSubnet-NSG
│   ├── Allow HTTP (80)
│   ├── 
│   └── Allow SSH (22) from your IP
└── PrivateSubnet-NSG
    ├── Allow HTTP from Public Subnet
    └── Allow SSH from Public Subnet
```

## ❓ Troubleshooting

**Website not loading?**
- Wait 2-3 minutes for VMs to initialize
- Check: `az vm list -g MyWebAppResourceGroup -o table`

**Can't SSH?**
- Verify your source IP hasn't changed
- Check NSG rules: `az network nsg rule list -g MyWebAppResourceGroup --nsg-name PublicSubnet-NSG -o table`

**Private VM not responding?**
- SSH to Public VM first
- Test: `curl http://10.0.2.4`
- Check logs: `sudo tail -f /var/log/nginx/error.log`

## 💰 Cost

~$94/month for 2x Standard_B2s VMs in East US

## 🎯 Next Steps

1. ✅ Deploy the infrastructure
2. ✅ Access your website
3. ✅ Customize the content
4. 🔐 Add SSL certificate
5. 📊 Set up monitoring
6. 🚀 Scale as needed
