## Custom data script to install google chrome + IIS
$ErrorActionPreference = "Stop"

Write-Output "Installing Chrome..."
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$chromeInstaller = "$env:TEMP\chrome_installer.exe"
Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller
Start-Process -FilePath $chromeInstaller -ArgumentList "/silent /install" -Wait

Write-Output "Installing IIS..."
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Write-Output "Creating test HTML page..."
$html = @"
<!DOCTYPE html>
<html>
<head>
<title>VMSS IIS Test Successful</title>
</head>
<body>
<h1>IIS is running on VM Scale Set</h1>
<p>Served from: $env:COMPUTERNAME</p>
</body>
</html>
"@

$html | Out-File "C:\inetpub\wwwroot\index.html" -Encoding utf8 -Force

Write-Output "Starting IIS service..."
Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic

Write-Output "Setup complete"

