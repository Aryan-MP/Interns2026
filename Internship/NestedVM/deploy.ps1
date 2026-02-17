param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$Location,

    [Parameter(Mandatory=$true)]
    [string]$VmName,

    [Parameter(Mandatory=$true)]
    [string]$AdminUsername,

    [Parameter(Mandatory=$true)]
    [SecureString]$AdminPassword,

    [ValidateSet("Incremental","Complete")]
    [string]$DeploymentMode = "Incremental"
)

$ErrorActionPreference = "Stop"

# Convert secure string for ARM
$PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPassword)
)

$logFile = ".\deployment-$(Get-Date -Format yyyyMMdd-HHmmss).log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp - $Message"
    Write-Host $entry
    Add-Content -Path $logFile -Value $entry
}

function Deploy-Template {
    param([string]$TemplateFile)

    Write-Log "Validating $TemplateFile..."

    Test-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFile `
        -Mode $DeploymentMode `
        -vmName $VmName `
        -adminUsername $AdminUsername `
        -adminPassword $PlainPassword `
        -ErrorAction Stop | Out-Null

    Write-Log "Deploying $TemplateFile..."

    New-AzResourceGroupDeployment `
        -Name ("deploy-" + (Split-Path $TemplateFile -Leaf) + "-" + (Get-Date -Format HHmmss)) `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFile `
        -Mode $DeploymentMode `
        -vmName $VmName `
        -adminUsername $AdminUsername `
        -adminPassword $PlainPassword `
        -Verbose `
        -ErrorAction Stop | Out-Null

    Write-Log "$TemplateFile deployment succeeded."
}

# ----------------------------
# EXECUTION START
# ----------------------------

Write-Log "Starting deployment orchestration..."

if (-not (Get-AzContext)) {
    Write-Log "Connecting to Azure..."
    Connect-AzAccount
}

# Ensure Resource Group exists
if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
    Write-Log "Creating Resource Group $ResourceGroupName"
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location | Out-Null
}

# Ordered execution based on filename prefix
$templates = Get-ChildItem -Filter "*.json" |
    Where-Object { $_.Name -match "^\d+" } |
    Sort-Object Name

foreach ($template in $templates) {
    Deploy-Template $template.FullName
}

Write-Log "All templates deployed successfully."
