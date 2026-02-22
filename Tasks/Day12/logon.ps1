# Runs via Custom Script Extension on first boot.
# Installs IIS immediately, then installs VS Code + Python + extensions on first RDP login.

# Force TLS 1.2 for all web downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#  1. Install IIS 
Install-WindowsFeature -Name Web-Server -IncludeManagementTools -IncludeAllSubFeature
Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic
New-NetFirewallRule -DisplayName "HTTP-80" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow -Profile Any -ErrorAction SilentlyContinue

#  2. Write custom IIS HTML page 
$html = '<!DOCTYPE html><html><head><meta charset="UTF-8"/><title>Welcome</title><style>body{font-family:Segoe UI,Arial,sans-serif;background:#0078d4;color:#fff;display:flex;justify-content:center;align-items:center;height:100vh;margin:0}.card{background:rgba(255,255,255,.13);border-radius:14px;padding:52px 72px;text-align:center;max-width:600px}h1{font-size:2.4rem;margin-bottom:12px}p{font-size:1.05rem;opacity:.9;margin-top:10px}</style></head><body><div class="card"><h1>Hello from Azure!</h1><p>This VM was provisioned via ARM template.</p><p>IIS is running &#10003;</p></div></body></html>'
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value $html -Encoding UTF8
Set-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $html -Encoding UTF8

#  3. Install Chocolatey 
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

#  4. Install Python and VS Code via Chocolatey 
choco install python vscode -y --no-progress

#  5. Write extension install script to a shared location 
# This runs in the USER session via RunOnce, so extensions go into the correct profile.
$extensionScript = @"
Start-Sleep -Seconds 15
& 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-python.python --force
& 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-vscode.powershell --force
"@
Set-Content -Path "C:\Users\Public\install_extensions.ps1" -Value $extensionScript -Encoding UTF8

#  6. Register RunOnce - fires once at next user logon, then removes itself 
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" `
    -Name "InstallVSExtensions" `
    -Value "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Users\Public\install_extensions.ps1"