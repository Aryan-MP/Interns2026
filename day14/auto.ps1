# --- CONFIGURATION ---
$rgName = "tkirangowda15-rg"
$location = "westus2"
$templateFile = ".\arm-lb-linux-template.json"
$vmSize = "Standard_B2as_v2" 

# --- STEP 1: NUCLEAR CLEAN (Free up Quota) ---
Write-Host ">>> CLEANING OLD LAB RESOURCES TO FREE UP QUOTA..." -ForegroundColor Cyan
Get-AzResource -ResourceGroupName $rgName | Remove-AzResource -Force -ErrorAction SilentlyContinue
Write-Host ">>> Clean complete. Starting fresh." -ForegroundColor Green

# --- STEP 2: CLOUD-INIT SCRIPTS (Base64 Encoded for Linux) ---
$script1 = "#!/bin/bash`napt-get update`napt-get install -y apache2`necho ""<h1 style='font-size: 80px; color: blue; text-align: center; margin-top: 15%;'>Welcome to ARM VM 1 (Blue)</h1>"" > /var/www/html/index.html`nsystemctl restart apache2"
$encoded1 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($script1))

$script2 = "#!/bin/bash`napt-get update`napt-get install -y apache2`necho ""<h1 style='font-size: 80px; color: green; text-align: center; margin-top: 15%;'>Welcome to ARM VM 2 (Green)</h1>"" > /var/www/html/index.html`nsystemctl restart apache2"
$encoded2 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($script2))

# --- STEP 3: GENERATE THE "ALL-IN-ONE" ARM TEMPLATE ---
$jsonContent = @"
{
  "`$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "variables": {
    "vnetName": "ARM-VNet",
    "nsgName": "ARM-NSG",
    "pipName": "ARM-LB-PIP",
    "lbName": "ARM-LoadBalancer",
    "nic1Name": "ARM-VM1-NIC",
    "nic2Name": "ARM-VM2-NIC"
  },
  "resources": [
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2020-06-01",
      "name": "[variables('nsgName')]",
      "location": "$location",
      "properties": {
        "securityRules": [
          { "name": "AllowHTTP", "properties": { "priority": 100, "protocol": "Tcp", "access": "Allow", "direction": "Inbound", "sourceAddressPrefix": "*", "sourcePortRange": "*", "destinationAddressPrefix": "*", "destinationPortRange": "80" } },
          { "name": "AllowSSH", "properties": { "priority": 110, "protocol": "Tcp", "access": "Allow", "direction": "Inbound", "sourceAddressPrefix": "*", "sourcePortRange": "*", "destinationAddressPrefix": "*", "destinationPortRange": "22" } }
        ]
      }
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2020-06-01",
      "name": "[variables('pipName')]",
      "location": "$location",
      "sku": { "name": "Standard" },
      "properties": { "publicIPAllocationMethod": "Static" }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2020-06-01",
      "name": "[variables('vnetName')]",
      "location": "$location",
      "properties": {
        "addressSpace": { "addressPrefixes": [ "10.3.0.0/16" ] },
        "subnets": [ { "name": "default", "properties": { "addressPrefix": "10.3.0.0/24", "networkSecurityGroup": { "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]" } } } ]
      }
    },
    {
      "type": "Microsoft.Network/loadBalancers",
      "apiVersion": "2020-06-01",
      "name": "[variables('lbName')]",
      "location": "$location",
      "sku": { "name": "Standard" },
      "dependsOn": [ "[resourceId('Microsoft.Network/publicIPAddresses', variables('pipName'))]" ],
      "properties": {
        "frontendIPConfigurations": [ { "name": "FrontEndIP", "properties": { "publicIPAddress": { "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('pipName'))]" } } } ],
        "backendAddressPools": [ { "name": "BackendPool" } ],
        "probes": [ { "name": "HTTP-Probe", "properties": { "protocol": "Http", "port": 80, "requestPath": "/", "intervalInSeconds": 5, "numberOfProbes": 2 } } ],
        "loadBalancingRules": [ { "name": "Web-Rule", "properties": { "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', variables('lbName'), 'FrontEndIP')]" }, "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', variables('lbName'), 'BackendPool')]" }, "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', variables('lbName'), 'HTTP-Probe')]" }, "protocol": "Tcp", "frontendPort": 80, "backendPort": 80, "idleTimeoutInMinutes": 4 } } ]
      }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2020-06-01",
      "name": "[variables('nic1Name')]",
      "location": "$location",
      "dependsOn": [ "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]", "[resourceId('Microsoft.Network/loadBalancers', variables('lbName'))]" ],
      "properties": { "ipConfigurations": [ { "name": "ipconfig1", "properties": { "privateIPAllocationMethod": "Dynamic", "subnet": { "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), 'default')]" }, "loadBalancerBackendAddressPools": [ { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', variables('lbName'), 'BackendPool')]" } ] } } ] }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2020-06-01",
      "name": "[variables('nic2Name')]",
      "location": "$location",
      "dependsOn": [ "[resourceId('Microsoft.Network/virtualNetworks', variables('vnetName'))]", "[resourceId('Microsoft.Network/loadBalancers', variables('lbName'))]" ],
      "properties": { "ipConfigurations": [ { "name": "ipconfig1", "properties": { "privateIPAllocationMethod": "Dynamic", "subnet": { "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('vnetName'), 'default')]" }, "loadBalancerBackendAddressPools": [ { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', variables('lbName'), 'BackendPool')]" } ] } } ] }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2020-06-01",
      "name": "ARM-VM1",
      "location": "$location",
      "dependsOn": [ "[resourceId('Microsoft.Network/networkInterfaces', variables('nic1Name'))]" ],
      "properties": {
        "hardwareProfile": { "vmSize": "$vmSize" },
        "osProfile": { "computerName": "armvm1", "adminUsername": "useradmin", "adminPassword": "Student@123456", "customData": "$encoded1" },
        "storageProfile": { "imageReference": { "publisher": "Canonical", "offer": "0001-com-ubuntu-server-jammy", "sku": "22_04-lts-gen2", "version": "latest" }, "osDisk": { "createOption": "FromImage" } },
        "networkProfile": { "networkInterfaces": [ { "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nic1Name'))]" } ] }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2020-06-01",
      "name": "ARM-VM2",
      "location": "$location",
      "dependsOn": [ "[resourceId('Microsoft.Network/networkInterfaces', variables('nic2Name'))]" ],
      "properties": {
        "hardwareProfile": { "vmSize": "$vmSize" },
        "osProfile": { "computerName": "armvm2", "adminUsername": "useradmin", "adminPassword": "Student@123456", "customData": "$encoded2" },
        "storageProfile": { "imageReference": { "publisher": "Canonical", "offer": "0001-com-ubuntu-server-jammy", "sku": "22_04-lts-gen2", "version": "latest" }, "osDisk": { "createOption": "FromImage" } },
        "networkProfile": { "networkInterfaces": [ { "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nic2Name'))]" } ] }
      }
    }
  ]
}
"@
Set-Content -Path $templateFile -Value $jsonContent

# --- STEP 4: DEPLOY TO AZURE ---
Write-Host ">>> DEPLOYING FULL INFRASTRUCTURE VIA ARM TEMPLATE..." -ForegroundColor Yellow

try {
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $templateFile -Verbose -ErrorAction Stop
    
    # Fetch the Load Balancer IP Address directly after successful build
    $pip = Get-AzPublicIpAddress -ResourceGroupName $rgName -Name "ARM-LB-PIP"
    
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host ">>> DEPLOYMENT COMPLETE! INFRASTRUCTURE IS LIVE." -ForegroundColor Green
    Write-Host ">>> TEST YOUR LOAD BALANCER HERE:" -ForegroundColor White
    Write-Host "http://$($pip.IpAddress)" -ForegroundColor Yellow
    Write-Host "=======================================================" -ForegroundColor Cyan
} catch {
    Write-Host "`n>>> DEPLOYMENT FAILED!" -ForegroundColor Red
    Write-Host "If this fails again, run this command to see the inner error details:" -ForegroundColor Gray
    Write-Host "Get-AzLog -CorrelationId `"$($_.Exception.Message | Select-String -Pattern '([a-f0-9\-]{36})' | %{$_.Matches.Value})`" | Select-Object -ExpandProperty Properties" -ForegroundColor White
}