# ==============================
# Custom Script Extension - Windows VM
# ==============================

# Output directory for status
$OutDir = "C:\CSE"
New-Item $OutDir -ItemType Directory -Force | Out-Null

# ==============================
# Install IIS
# ==============================
$IIS = $false
$HtmlPath = "C:\inetpub\wwwroot\index.html"

if (Get-Command Install-WindowsFeature -ErrorAction SilentlyContinue) {
    # Server OS
    Install-WindowsFeature Web-Server -ErrorAction SilentlyContinue | Out-Null
    $IIS = $true
} else {
    # Client OS (Windows 10/11)
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart | Out-Null
    $IIS = $true
}

# ==============================
# Deploy Custom HTML
# ==============================
$HtmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My VM</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f8ff; text-align: center; padding-top: 50px; }
        h1 { color: #2e8b57; }
        p { font-size: 18px; }
    </style>
</head>
<body>
    <h1>🎉 IIS is Running!</h1>
    <p>This is a custom HTML page deployed via Custom Script Extension.</p>
    <p>Chrome Installation Status: <span id='chrome-status'>Pending</span></p>
</body>
</html>
"@

# Create IIS root if missing
if (-not (Test-Path "C:\inetpub\wwwroot")) {
    New-Item "C:\inetpub\wwwroot" -ItemType Directory -Force | Out-Null
}

# Write custom HTML
$HtmlContent | Out-File $HtmlPath -Force

# ==============================
# Install Chrome
# ==============================
$Chrome = $false
$ChromePath = "C:\Temp\chrome_installer.exe"

# Create temp folder if missing
if (-not (Test-Path "C:\Temp")) {
    New-Item "C:\Temp" -ItemType Directory -Force | Out-Null
}

# Download Chrome installer
Invoke-WebRequest 
    -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" 
    -OutFile $ChromePath

# Install Chrome silently
Start-Process $ChromePath -ArgumentList "/silent /install" -Wait
$Chrome = $true

# ==============================
# Update HTML with Chrome status
# ==============================
if ($IIS -eq $true -and (Test-Path $HtmlPath)) {
    $status = if ($Chrome) { "Installed" } else { "Failed" }
    (Get-Content $HtmlPath) -replace "Pending", $status | Set-Content $HtmlPath
}

# ==============================
# Output Status JSON
# ==============================
@{
    IIS      = $IIS
    Chrome   = $Chrome
    HtmlPage = $HtmlPath
} | ConvertTo-Json | Out-File "$OutDir\cse_status.json" -Force



