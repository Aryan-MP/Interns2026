<powershell>
# Enable logging
Start-Transcript -Path "C:\AzureUserData.log" -Append

Write-Host "Installing IIS..."

# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Start IIS
Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic

Write-Host "IIS Installed"

# Create default web page
$sitePath = "C:\inetpub\wwwroot\index.html"
"<!DOCTYPE html>
<html>
<head><title>Azure IIS</title></head>
<body>
<h1>IIS Installed Successfully on Azure VM</h1>
</body>
</html>" | Out-File $sitePath -Encoding utf8 -Force

# -----------------------------
# Install Google Chrome
# -----------------------------
Write-Host "Installing Chrome..."

$chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
$chromeInstaller = "C:\Windows\Temp\chrome.msi"

Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller

Start-Process msiexec.exe -ArgumentList "/i `"$chromeInstaller`" /qn" -Wait

Write-Host "Chrome Installed"

Stop-Transcript
</powershell>
