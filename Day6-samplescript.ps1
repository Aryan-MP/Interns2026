$OutDir = "C:\CSE"
New-Item $OutDir -ItemType Directory -Force | Out-Null

# IIS (Server OS)
if (Get-Command Install-WindowsFeature -ErrorAction SilentlyContinue) {
    Install-WindowsFeature Web-Server -ErrorAction SilentlyContinue | Out-Null
    "Hello" | Out-File C:\inetpub\wwwroot\index.html -Force
    $IIS = $true
} else {
    # IIS (Client OS)
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
    "Hello" | Out-File C:\inetpub\wwwroot\index.html -Force
    $IIS = $true
}

# Chrome
$ChromePath = "C:\Temp\chrome.exe"
New-Item C:\Temp -ItemType Directory -Force | Out-Null
Invoke-WebRequest `
    -Uri "https://dl.google.com/chrome/install/375.126/chrome_installer.exe" `
    -OutFile $ChromePath

Start-Process $ChromePath -ArgumentList "/silent /install" -Wait
$Chrome = $true

@{
    IIS     = $IIS
    Chrome = $Chrome
    IISData = "Hello"
} | ConvertTo-Json | Out-File "$OutDir\cse_status.json" -Force