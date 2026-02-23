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
code --install-extension ms-vscode.azure-account --force

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
Write-Host "Setup completed."