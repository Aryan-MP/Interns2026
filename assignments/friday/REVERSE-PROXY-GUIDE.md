# Azure VNet with Reverse Proxy Configuration

This ARM template creates a network topology where a **Public VM acts as a Reverse Proxy** to forward HTTP traffic to a Private VM running Nginx. Users can access the private VM's web server directly through the public VM's public IP address.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         INTERNET                            │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    HTTP Request (Port 80)
                           │
                           ▼
            ┌──────────────────────────────┐
            │   PUBLIC VM (Reverse Proxy)  │
            │   • Has Public IP            │
            │   • Nginx Reverse Proxy      │
            │   • Public Subnet            │
            │   • IP: 10.0.1.x             │
            └──────────────┬───────────────┘
                           │
                  Forwards Request
                           │
                           ▼
            ┌──────────────────────────────┐
            │   PRIVATE VM (Backend)       │
            │   • NO Public IP             │
            │   • Nginx Web Server         │
            │   • Private Subnet           │
            │   • IP: 10.0.2.x             │
            └──────────────────────────────┘
```

## ✨ Key Features

✅ **Reverse Proxy**: Public VM forwards all HTTP traffic to private VM
✅ **Direct Browser Access**: Access private VM content via public IP
✅ **Security**: Private VM remains isolated from internet
✅ **Health Endpoints**: Built-in health check and status endpoints
✅ **Auto-Configuration**: Reverse proxy automatically configured
✅ **Professional Setup**: Proper headers, timeouts, and WebSocket support

## 🎯 What Gets Deployed

### Network Infrastructure:
- **VNet**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24 (with NSG allowing SSH + HTTP)
- **Private Subnet**: 10.0.2.0/24 (with NSG allowing only traffic from public subnet)
- **Public IP**: Attached to public VM

### Virtual Machines:
1. **Public VM (Reverse Proxy)**:
   - Ubuntu 22.04 LTS
   - Nginx configured as reverse proxy
   - Forwards all traffic to private VM
   - Accessible from internet on port 80
   
2. **Private VM (Backend Server)**:
   - Ubuntu 22.04 LTS
   - Nginx web server with custom page
   - No public IP
   - Only accessible from public subnet

## 🚀 Quick Deployment

### Using Azure CLI

```bash
# Create resource group
az group create --name reverseProxyRG --location eastus

# Deploy template
az deployment group create \
  --resource-group reverseProxyRG \
  --template-file vnet-reverse-proxy-template.json \
  --parameters projectName=demo adminUsername=azureuser adminPassword='YourSecurePass123!'
```

### Using PowerShell

```powershell
# Create resource group
New-AzResourceGroup -Name reverseProxyRG -Location "East US"

# Deploy template
New-AzResourceGroupDeployment `
  -ResourceGroupName reverseProxyRG `
  -TemplateFile .\vnet-reverse-proxy-template.json `
  -projectName demo `
  -adminUsername azureuser `
  -adminPassword (ConvertTo-SecureString "YourSecurePass123!" -AsPlainText -Force)
```

### Using Azure Portal

1. Navigate to **Azure Portal** → **Create a resource**
2. Search for **"Template deployment"**
3. Select **"Build your own template in the editor"**
4. Copy and paste the template JSON
5. Click **"Save"**
6. Fill in parameters:
   - Project Name: `demo`
   - Admin Username: `azureuser`
   - Admin Password: (secure password)
7. Click **"Review + create"** → **"Create"**

## 🔍 Testing the Deployment

### 1. Get the Public IP

After deployment completes, get the public IP from outputs:

```bash
az deployment group show \
  --resource-group reverseProxyRG \
  --name vnet-reverse-proxy-template \
  --query properties.outputs.publicVmPublicIP.value -o tsv
```

### 2. Access in Browser

Simply open your browser and navigate to:
```
http://<PUBLIC_VM_IP>
```

You should see the private VM's Nginx welcome page! 🎉

### 3. Test with curl

```bash
# Access the private VM through reverse proxy
curl http://<PUBLIC_VM_IP>

# Check proxy health
curl http://<PUBLIC_VM_IP>/health

# Check proxy status and backend info
curl http://<PUBLIC_VM_IP>/proxy-status
```

## 📊 Built-in Endpoints

The reverse proxy comes with useful monitoring endpoints:

| Endpoint | Description | Example |
|----------|-------------|---------|
| `/` | Main content (proxied to private VM) | `http://<PUBLIC_IP>/` |
| `/health` | Health check endpoint | `http://<PUBLIC_IP>/health` |
| `/proxy-status` | Shows proxy configuration and backend IP | `http://<PUBLIC_IP>/proxy-status` |

## 🔧 Reverse Proxy Configuration

The public VM's Nginx is configured with:

```nginx
server {
    listen 80 default_server;
    
    location / {
        proxy_pass http://<PRIVATE_VM_IP>:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

### Features:
- ✅ Proper HTTP headers forwarding
- ✅ Real client IP preservation
- ✅ WebSocket support
- ✅ Reasonable timeout values
- ✅ HTTP/1.1 protocol support

## 📋 Deployment Outputs

After successful deployment, you'll receive:

| Output | Description |
|--------|-------------|
| `reverseProxyURL` | Direct URL to access (http://PUBLIC_IP) |
| `reverseProxyFQDN` | DNS name URL (http://name.region.cloudapp.azure.com) |
| `proxyHealthCheck` | Health check endpoint URL |
| `proxyStatus` | Proxy status endpoint URL |
| `publicVmPublicIP` | Public IP address |
| `privateVmPrivateIP` | Private backend IP |
| `vnetName` | Virtual network name |
| `quickTestCommand` | Ready-to-use curl command |

## 🧪 Verification Steps

### Step 1: Test Direct Access
```bash
# This should show the private VM's HTML page
curl http://<PUBLIC_VM_IP>
```

### Step 2: Verify Proxy Health
```bash
# Should return: "Reverse Proxy is healthy"
curl http://<PUBLIC_VM_IP>/health
```

### Step 3: Check Proxy Configuration
```bash
# Shows backend IP and proxy status
curl http://<PUBLIC_VM_IP>/proxy-status
```

### Step 4: Browser Test
Open your browser and navigate to:
- `http://<PUBLIC_IP>` - See the private VM's page
- `http://<PUBLIC_IP>/proxy-status` - View proxy details

### Step 5: Verify Private VM is Isolated
```bash
# This should TIMEOUT (confirming private VM has no public access)
curl --connect-timeout 5 http://<PRIVATE_VM_IP>
```

## 🔐 Security Features

1. **Private VM Isolation**:
   - No public IP assigned
   - NSG blocks all internet traffic
   - Only accepts connections from public subnet

2. **Public VM Protection**:
   - NSG allows only SSH (22) and HTTP (80)
   - Acts as single entry point
   - Can add authentication/rate limiting

3. **Network Segmentation**:
   - Clear separation between public and private subnets
   - Controlled traffic flow
   - Easy to audit and monitor

## 📝 Use Cases

This architecture is perfect for:

1. **Web Applications**: Front-end in public, backend APIs in private
2. **Microservices**: API gateway pattern
3. **Database Access**: Web app in public, database in private
4. **Content Delivery**: Static content proxy to private storage
5. **Security Compliance**: Hide internal services from internet
6. **Load Balancing**: Can add multiple backend servers
7. **SSL Termination**: Add SSL/TLS at proxy level

## 🛠️ Troubleshooting

### Issue: Cannot access via public IP

**Check 1**: Verify deployment completed
```bash
az deployment group show \
  --resource-group reverseProxyRG \
  --name vnet-reverse-proxy-template \
  --query properties.provisioningState
```

**Check 2**: Verify both VMs are running
```bash
az vm list --resource-group reverseProxyRG --output table
```

**Check 3**: Check NSG rules
```bash
az network nsg rule list \
  --resource-group reverseProxyRG \
  --nsg-name <NSG_NAME> \
  --output table
```

### Issue: 502 Bad Gateway error

This means the proxy is working but can't reach the backend.

**Solution 1**: Wait 2-3 minutes for extensions to complete

**Solution 2**: SSH to public VM and check:
```bash
ssh azureuser@<PUBLIC_IP>

# Check Nginx status
sudo systemctl status nginx

# Check if private VM is reachable
curl http://<PRIVATE_VM_IP>

# View Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Issue: Nginx not starting on private VM

**SSH through public VM**:
```bash
ssh azureuser@<PUBLIC_IP>
ssh azureuser@<PRIVATE_IP>

# Check Nginx status
sudo systemctl status nginx

# Restart if needed
sudo systemctl restart nginx

# Check logs
sudo journalctl -u nginx -n 50
```

### Issue: Extensions taking too long

Check extension status:
```bash
az vm extension list \
  --resource-group reverseProxyRG \
  --vm-name <VM_NAME> \
  --query "[].{Name:name, Status:provisioningState}" \
  --output table
```

## 🔄 Customization Options

### Add SSL/HTTPS Support

1. SSH to public VM
2. Install Certbot:
```bash
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx
```

3. Get certificate:
```bash
sudo certbot --nginx -d your-domain.com
```

### Add Multiple Backend Servers

Modify the Nginx configuration to load balance:
```nginx
upstream backend_servers {
    server 10.0.2.4:80;
    server 10.0.2.5:80;
    server 10.0.2.6:80;
}

server {
    location / {
        proxy_pass http://backend_servers;
    }
}
```

### Add Authentication

Install and configure HTTP basic auth:
```bash
# On public VM
sudo apt-get install -y apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd admin

# Add to Nginx config
auth_basic "Restricted Access";
auth_basic_user_file /etc/nginx/.htpasswd;
```

### Enable Access Logging

Add to Nginx config:
```nginx
access_log /var/log/nginx/proxy-access.log;
error_log /var/log/nginx/proxy-error.log;
```

## 📈 Monitoring

### View Access Logs
```bash
ssh azureuser@<PUBLIC_IP>
sudo tail -f /var/log/nginx/access.log
```

### Check Connections
```bash
# On public VM
sudo netstat -an | grep :80
```

### Monitor Backend Health
```bash
# Create a monitoring script
curl -s http://<PUBLIC_IP>/proxy-status
```

## 💰 Cost Estimation

- 2x Standard_B2s VMs: ~$60-80/month
- 1x Standard Public IP: ~$3-4/month  
- 2x Premium SSD (128GB): ~$20-30/month
- Bandwidth (egress): ~$5-10/month (varies by usage)

**Total: ~$90-125/month** (varies by region)

## 🧹 Cleanup

To delete all resources:

```bash
az group delete --name reverseProxyRG --yes --no-wait
```

## 📚 Additional Resources

- [Nginx Reverse Proxy Documentation](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)
- [Azure NSG Rules](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)
- [Azure ARM Template Reference](https://docs.microsoft.com/azure/templates/)

## 🎓 Learning Points

This template demonstrates:
- ✅ Reverse proxy pattern implementation
- ✅ Network security group configuration
- ✅ Multi-tier network architecture
- ✅ Secure service exposure
- ✅ Infrastructure as Code (IaC)
- ✅ Azure VM extensions for automation

## 🚀 Next Steps

1. **Add HTTPS**: Install SSL certificates with Let's Encrypt
2. **Load Balancing**: Deploy multiple backend servers
3. **Caching**: Configure Nginx caching for better performance
4. **Monitoring**: Set up Azure Monitor and Log Analytics
5. **Auto-scaling**: Implement VMSS for backend servers
6. **WAF**: Add Azure Application Gateway with WAF rules

---

**Happy Deploying! 🎉**

For issues or questions, check the troubleshooting section or review Azure deployment logs.
