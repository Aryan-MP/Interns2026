# Azure ARM Template Deployment Script (PowerShell)
# This script deploys the VNet infrastructure with public and private subnets

# Configuration
$ResourceGroup = "sivakumarderangula-rg"
$Location = "eastus"
$DeploymentName = "vnet-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "========================================" -ForegroundColor Green
Write-Host "Azure VNet Deployment Script" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Prompt for required parameters
Write-Host "Please provide the following information:" -ForegroundColor Yellow
Write-Host ""

$rgInput = Read-Host "Resource Group Name [$ResourceGroup]"
if ($rgInput) { $ResourceGroup = $rgInput }

$locInput = Read-Host "Location [$Location]"
if ($locInput) { $Location = $locInput }

$adminInput = Read-Host "Admin Username [azureuser]"
$AdminUsername = if ($adminInput) { $adminInput } else { "azureuser" }

Write-Host ""
Write-Host "Choose authentication method:" -ForegroundColor Yellow
Write-Host "1. SSH Key (recommended)"
Write-Host "2. Password"
$authChoice = Read-Host "Enter choice [1]"
if (-not $authChoice) { $authChoice = "1" }

if ($authChoice -eq "2") {
    # Password authentication
    $AuthType = "password"
    Write-Host ""
    Write-Host "Password Requirements:" -ForegroundColor Yellow
    Write-Host "- At least 12 characters long" -ForegroundColor Yellow
    Write-Host "- Must contain uppercase, lowercase, number, and special character" -ForegroundColor Yellow
    Write-Host ""
    
    do {
        $SecurePassword = Read-Host "Enter VM Password" -AsSecureString
        $SecurePasswordConfirm = Read-Host "Confirm VM Password" -AsSecureString
        
        $BSTR1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $BSTR2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePasswordConfirm)
        $Password1 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR1)
        $Password2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR2)
        
        if ($Password1 -ne $Password2) {
            Write-Host "Passwords do not match. Please try again." -ForegroundColor Red
            Write-Host ""
        }
        elseif ($Password1.Length -lt 12) {
            Write-Host "Password must be at least 12 characters long. Please try again." -ForegroundColor Red
            Write-Host ""
        }
        else {
            $AdminCredential = $Password1
            break
        }
        
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR1)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR2)
    } while ($true)
}
else {
    # SSH Key authentication (default)
    $AuthType = "sshPublicKey"
    
    # Check if SSH key exists
    $sshKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"
    if (Test-Path $sshKeyPath) {
        $AdminCredential = Get-Content $sshKeyPath -Raw
        Write-Host "Found existing SSH key" -ForegroundColor Green
    }
    else {
        Write-Host "No SSH key found. Please generate one using: ssh-keygen -t rsa -b 4096" -ForegroundColor Yellow
        Write-Host "Or enter your SSH public key manually:" -ForegroundColor Yellow
        $AdminCredential = Read-Host "SSH Public Key"
    }
}

Write-Host ""
$sourceIpInput = Read-Host "Enter your public IP for SSH access (leave empty for '*' - not recommended)"
$SourceIP = if ($sourceIpInput) { $sourceIpInput } else { "*" }

Write-Host ""
Write-Host "Checking Azure connection..." -ForegroundColor Green

# Check if logged in to Azure
try {
    $account = Get-AzContext
    if (-not $account) {
        Write-Host "Please login to Azure..." -ForegroundColor Yellow
        Connect-AzAccount
    }
}
catch {
    Write-Host "Please login to Azure..." -ForegroundColor Yellow
    Connect-AzAccount
}

Write-Host ""
Write-Host "Checking resource group: $ResourceGroup" -ForegroundColor Green
$rg = Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue
if ($rg) {
    Write-Host "Resource group already exists, using existing one" -ForegroundColor Yellow
} else {
    Write-Host "Creating resource group: $ResourceGroup" -ForegroundColor Green
    New-AzResourceGroup -Name $ResourceGroup -Location $Location -Force | Out-Null
}

Write-Host ""
Write-Host "Starting deployment: $DeploymentName" -ForegroundColor Green
Write-Host "This may take 5-10 minutes..." -ForegroundColor Yellow
Write-Host ""

# Deploy the ARM template
try {
    # Prepare parameters based on authentication type
    if ($AuthType -eq "password") {
        # Convert password string to SecureString
        $SecureAdminCredential = ConvertTo-SecureString -String $AdminCredential -AsPlainText -Force
        
        $deployment = New-AzResourceGroupDeployment `
            -Name $DeploymentName `
            -ResourceGroupName $ResourceGroup `
            -TemplateFile ".\azuredeploy.json" `
            -location $Location `
            -adminUsername $AdminUsername `
            -authenticationType $AuthType `
            -adminPasswordOrKey $SecureAdminCredential `
            -allowedSourceIP $SourceIP `
            -Verbose
    }
    else {
        # SSH key - pass as string
        $deployment = New-AzResourceGroupDeployment `
            -Name $DeploymentName `
            -ResourceGroupName $ResourceGroup `
            -TemplateFile ".\azuredeploy.json" `
            -location $Location `
            -adminUsername $AdminUsername `
            -authenticationType $AuthType `
            -adminPasswordOrKey $AdminCredential `
            -allowedSourceIP $SourceIP `
            -Verbose
    }
    
    if ($deployment.ProvisioningState -eq "Succeeded") {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "Deployment Successful!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        
        # Extract outputs
        $publicIP = $deployment.Outputs.publicVmIP.Value
        $publicFQDN = $deployment.Outputs.publicVmFQDN.Value
        $privateIP = $deployment.Outputs.privateVmIP.Value
        $websiteUrl = $deployment.Outputs.websiteUrl.Value
        $sshCommand = $deployment.Outputs.sshCommand.Value
        
        Write-Host "Deployment Information:" -ForegroundColor Green
        Write-Host "----------------------------------------"
        Write-Host "Public VM IP:       $publicIP"
        Write-Host "Public VM FQDN:     $publicFQDN"
        Write-Host "Private VM IP:      $privateIP"
        Write-Host ""
        Write-Host "Access Your Website:" -ForegroundColor Green
        Write-Host "URL:                $websiteUrl"
        Write-Host ""
        Write-Host "SSH Access:" -ForegroundColor Green
        Write-Host "Command:            $sshCommand"
        Write-Host ""
        Write-Host "Note: It may take a few minutes for the VMs to complete their setup." -ForegroundColor Yellow
        Write-Host "The website will be available after Nginx is installed and configured." -ForegroundColor Yellow
        Write-Host ""
        
        # Save deployment info to file
        $deploymentInfo = @"
Azure VNet Deployment Information
==================================
Deployment Name:    $DeploymentName
Resource Group:     $ResourceGroup
Location:           $Location
Deployment Date:    $(Get-Date)

Network Configuration:
---------------------
VNet:               MyVNet (10.0.0.0/16)
Public Subnet:      PublicSubnet (10.0.1.0/24)
Private Subnet:     PrivateSubnet (10.0.2.0/24)

Virtual Machines:
-----------------
Public VM IP:       $publicIP
Public VM FQDN:     $publicFQDN
Private VM IP:      $privateIP

Access Information:
-------------------
Website URL:        $websiteUrl
SSH to Public VM:   $sshCommand
SSH to Private VM:  ssh $AdminUsername@$privateIP (from Public VM)

Security:
---------
Authentication:     $AuthType
Allowed SSH IP:     $SourceIP
"@
        
        $deploymentInfo | Out-File -FilePath "deployment-info.txt" -Encoding UTF8
        
        Write-Host "Deployment information saved to: deployment-info.txt" -ForegroundColor Green
        Write-Host ""
        
        # Test website availability
        Write-Host "Testing website availability..." -ForegroundColor Yellow
        Start-Sleep -Seconds 30
        
        for ($i = 1; $i -le 10; $i++) {
            try {
                $response = Invoke-WebRequest -Uri $websiteUrl -UseBasicParsing -TimeoutSec 5
                if ($response.StatusCode -eq 200) {
                    Write-Host "Website is now accessible!" -ForegroundColor Green
                    Write-Host ""
                    break
                }
            }
            catch {
                Write-Host "Waiting for website to be ready... (attempt $i/10)" -ForegroundColor Yellow
                Start-Sleep -Seconds 30
            }
        }
        
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "Next Steps:" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "1. Open your browser and visit: $websiteUrl"
        Write-Host "2. SSH to public VM: $sshCommand"
        Write-Host "3. From public VM, SSH to private VM: ssh $AdminUsername@$privateIP"
        Write-Host ""
        Write-Host "To delete all resources:" -ForegroundColor Yellow
        Write-Host "Remove-AzResourceGroup -Name $ResourceGroup -Force"
        Write-Host ""
    }
}
catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Deployment Failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    exit 1
}