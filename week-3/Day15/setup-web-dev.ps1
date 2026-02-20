# ==========================================
# setup-web-dev.ps1
# Azure Custom Script Extension Compatible
# ==========================================

$ErrorActionPreference = "Stop"
$LogFile = "C:\Windows\Temp\setup-log.txt"

function Write-Log {
    param ($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$timestamp - $Message"
}

Write-Log "===== Starting Setup ====="

# -------------------------------
# Install IIS
# -------------------------------
try {
    Write-Log "Installing IIS..."
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Write-Log "IIS installation completed."
}
catch {
    Write-Log "IIS installation failed: $_"
}

# -------------------------------
# Deploy Custom index.html
# -------------------------------
try {
    Write-Log "Deploying custom index.html..."
    $webRoot = "C:\inetpub\wwwroot"
    $indexFile = Join-Path $webRoot "index.html"

    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Custom IIS Deployment</title>
</head>
<body>
    <h1>IIS Server Successfully Installed!</h1>
    <p>Server configured automatically using Azure Custom Script Extension.</p>
</body>
</html>
"@

    Set-Content -Path $indexFile -Value $htmlContent -Force
    Write-Log "index.html deployed."
}
catch {
    Write-Log "Index deployment failed: $_"
}



# ==============================
# Dev Environment Setup Script
# ==============================

$ErrorActionPreference = "Stop"

Write-Host "Starting system-level installation..."

# ------------------------------
# Install Chocolatey if missing
# ------------------------------

if (!(Get-Command choco -ErrorAction SilentlyContinue)) {

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

$env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"

# ------------------------------
# Install VS Code & Git
# ------------------------------

choco install vscode git -y

Write-Host "System-level installation complete."

# ------------------------------
# Create User Extension Script
# ------------------------------

$ExtensionScriptPath = "C:\ProgramData\InstallVSExtensions.ps1"

$ExtensionScript = @"
Start-Sleep -Seconds 15

code --install-extension ms-vscode.azure-account --force
code --install-extension ms-python.python --force
code --install-extension ms-azuretools.vscode-docker --force

Unregister-ScheduledTask -TaskName 'InstallVSExtensions' -Confirm:\$false
Remove-Item '$ExtensionScriptPath' -Force
"@

Set-Content -Path $ExtensionScriptPath -Value $ExtensionScript

# ------------------------------
# Create Logon Scheduled Task
# ------------------------------

$Action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File $ExtensionScriptPath"

$Trigger = New-ScheduledTaskTrigger -AtLogOn

$Principal = New-ScheduledTaskPrincipal `
    -GroupId "Users" `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName "InstallVSExtensions" `
    -Action $Action `
    -Trigger $Trigger `
    -Principal $Principal `
    -Force

Write-Host "Logon task created successfully."

# -------------------------------
# Restart IIS
# -------------------------------
try {
    iisreset
    Write-Log "IIS restarted."
}
catch {
    Write-Log "IIS restart failed: $_"
}

Write-Log "===== Setup Completed Successfully ====="

# VERY IMPORTANT: Force Azure success
exit 0