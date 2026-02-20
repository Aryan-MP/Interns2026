# 1. Set Security Protocol to TLS 1.2 for modern downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. Install Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 3. Install Google Chrome and VS Code using Chocolatey
# -y automatically accepts all prompts
Write-Host "Installing Chrome and VS Code..."
choco install googlechrome vscode -y

# 4. Create a small script to install VS Code extensions at Logon
# (Extensions MUST be installed in the user context, not the SYSTEM context)
$ExtensionScript = @"
    # Wait for VS Code to be fully registered in the path
    Start-Sleep -Seconds 15
    & 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-vscode.powershell --force
    & 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-python.python --force
"@

$ExtensionScriptPath = "C:\Users\Public\install_extensions.ps1"
Set-Content -Path $ExtensionScriptPath -Value $ExtensionScript

# 5. Set Windows to run the extension script ONE TIME when you log in
$RunOnceCommand = "powershell.exe -ExecutionPolicy Bypass -File $ExtensionScriptPath"
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "InstallVSExtensions" -Value $RunOnceCommand

Write-Host "Provisioning complete. Apps will be there when you RDP in!"