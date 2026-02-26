# ==========================================
# Production CSE Script - Windows VM (Fixed)
# ==========================================

$ErrorActionPreference = "Stop"
$OutDir = "C:\CSE"
New-Item $OutDir -ItemType Directory -Force | Out-Null
$LogFile = "$OutDir\cse_log.txt"

function Write-Log {
    param([string]$Message)
    $Message | Out-File $LogFile -Append -Encoding UTF8
    Write-Output $Message
}

# Status tracker
$Status = @{
    IIS        = $false
    Chrome     = $false
    VSCode     = $false
    Extensions = $false
    HtmlPath   = ""
    Errors     = @()
}

# ==========================================
# Install IIS
# ==========================================
try {
    Write-Log "Installing IIS..."
    if (Get-Command Install-WindowsFeature -ErrorAction SilentlyContinue) {
        Install-WindowsFeature Web-Server | Out-Null
    } else {
        Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart | Out-Null
    }

    if (-not (Test-Path "C:\inetpub\wwwroot")) {
        New-Item "C:\inetpub\wwwroot" -ItemType Directory -Force | Out-Null
    }

    $Status.IIS = $true
    Write-Log "IIS installed successfully."
}
catch {
    $Status.Errors += "IIS Failed: $($_.Exception.Message)"
    Write-Log "IIS Failed: $($_.Exception.Message)"
}

# ==========================================
# Deploy HTML Page
# ==========================================
try {
    Write-Log "Deploying HTML page..."
    $HtmlPath = "C:\inetpub\wwwroot\index.html"
    $HtmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Azure VM Ready</title>
    <style>
        body { font-family: Arial; background-color: #f0f8ff; text-align: center; padding-top: 50px; }
        h1 { color: #2e8b57; }
    </style>
</head>
<body>
    <h1>VM Configured Successfully</h1>
    <p>Installed via Azure Custom Script Extension</p>
</body>
</html>
"@
    $HtmlContent | Out-File $HtmlPath -Force -Encoding UTF8
    $Status.HtmlPath = $HtmlPath
    Write-Log "HTML page deployed."
}
catch {
    $Status.Errors += "HTML Failed: $($_.Exception.Message)"
    Write-Log "HTML Failed: $($_.Exception.Message)"
}

# ==========================================
# Install Google Chrome (Silent)
# ==========================================
try {
    Write-Log "Installing Chrome..."
    $ChromeInstaller = "$env:TEMP\chrome_installer.exe"
    Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/standalone/ChromeSetup.exe" -OutFile $ChromeInstaller -UseBasicParsing
    Start-Process $ChromeInstaller -ArgumentList "/silent /install" -Wait

    if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
        $Status.Chrome = $true
        Write-Log "Chrome installed successfully."
    }
}
catch {
    $Status.Errors += "Chrome Failed: $($_.Exception.Message)"
    Write-Log "Chrome Failed: $($_.Exception.Message)"
}

# ==========================================
# Install VS Code (SYSTEM Installer)
# ==========================================
try {
    Write-Log "Installing VS Code..."
    $VSCodePath = "C:\Program Files\Microsoft VS Code\Code.exe"
    $VSInstaller = "$env:TEMP\vscode.exe"

    if (-not (Test-Path $VSCodePath)) {
        Invoke-WebRequest -Uri "https://update.code.visualstudio.com/latest/win32-x64/stable" -OutFile $VSInstaller -UseBasicParsing
        Start-Process $VSInstaller -ArgumentList "/VERYSILENT /NORESTART /ALLUSERS /MERGETASKS=!runcode" -Wait
    }

    if (Test-Path $VSCodePath) {
        $Status.VSCode = $true
        Write-Log "VS Code installed successfully."

        Start-Sleep -Seconds 10  # Allow VS Code to initialize

        # Install Extensions
        & "$VSCodePath" --install-extension ms-azuretools.vscode-azureresourcegroups --force
        & "$VSCodePath" --install-extension ms-dotnettools.csharp --force
        & "$VSCodePath" --install-extension ms-python.python --force

        $Status.Extensions = $true
        Write-Log "VS Code extensions installed."
    }
}
catch {
    $Status.Errors += "VSCode Failed: $($_.Exception.Message)"
    Write-Log "VSCode Failed: $($_.Exception.Message)"
}

# ==========================================
# Output JSON Status
# ==========================================
$Status | ConvertTo-Json -Depth 3 | Out-File "$OutDir\cse_status.json" -Force
Write-Log "CSE completed."
exit 0
