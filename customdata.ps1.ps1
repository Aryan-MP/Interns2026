<powershell>
# -----------------------------
# Install IIS
# -----------------------------
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# -----------------------------
# Create Sample Web Page
# -----------------------------
$webPath = "C:\inetpub\wwwroot"
$html = @"
<html>
<head>
<title>Azure IIS VM</title>
</head>
<body>
<h1>IIS Server is Running</h1>
<p>Deployed using Custom Data (User Data)</p>
</body>
</html>
"@

Set-Content -Path "$webPath\index.html" -Value $html

# -----------------------------
# Install Google Chrome
# -----------------------------
$chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
$chromeInstaller = "$env:TEMP\chrome.msi"

Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller

Start-Process msiexec.exe -ArgumentList "/i $chromeInstaller /qn" -Wait

# -----------------------------
# Start IIS
# -----------------------------
Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic
</powershell>
