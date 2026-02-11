$ErrorActionPreference = "SilentlyContinue"

Install-WindowsFeature -Name Web-Server -IncludeManagementTools

$html = "<html><body style='font-family:Arial;text-align:center;margin-top:80px;background:#111;color:white;'><h1>IIM USER</h1><p>IIS deployed successfully via ARM</p></body></html>"
Set-Content C:\inetpub\wwwroot\index.html $html

Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic

New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

# Install Chrome (optional — will not stop script if fails)
try {
    Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome/installers/GoogleChromeStandaloneEnterprise64.msi" -OutFile C:\chrome.msi
    Start-Process msiexec.exe -Wait -ArgumentList "/i C:\chrome.msi /quiet /norestart"
} catch {}

iisreset
