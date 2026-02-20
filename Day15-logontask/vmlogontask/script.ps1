# ============================================
# Start Logging
# ============================================
$OutDir = "C:\CSE"
New-Item $OutDir -ItemType Directory -Force | Out-Null
Start-Transcript -Path "$OutDir\script.log" -Force

Write-Host "===== CSE Script Started ====="

# ============================================
# Beautiful Vibrant HTML Content
# ============================================
$HtmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Azure Windows 11 VM</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1e3c72, #2a5298, #00c6ff);
            color: white;
            text-align: center;
        }
        .container { margin-top: 15%; }
        h1 { font-size: 48px; animation: glow 2s infinite alternate; }
        p { font-size: 22px; }
        .btn {
            padding: 15px 30px;
            background-color: #ff9800;
            border: none;
            border-radius: 30px;
            font-size: 18px;
            cursor: pointer;
            color: white;
            transition: 0.3s;
        }
        .btn:hover { background-color: #ff5722; transform: scale(1.1); }
        @keyframes glow {
            from { text-shadow: 0 0 10px #fff; }
            to { text-shadow: 0 0 30px #00ffff; }
        }
        footer {
            position: fixed;
            bottom: 10px;
            width: 100%;
            font-size: 14px;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Azure Windows 11 Pro VM</h1>
        <p>IIS Web Server Successfully Deployed</p>
        <p>Region: East US 2</p>
        <button class="btn" onclick="alert('Your IIS Server is Running Successfully!')">
            Click Me
        </button>
    </div>
    <footer>
        Deployed using ARM Template + Custom Script Extension
    </footer>
</body>
</html>
"@

# ============================================
# IIS Setup (Server or Client OS)
# ============================================
try {
    if (Get-Command Install-WindowsFeature -ErrorAction SilentlyContinue) {
        Install-WindowsFeature Web-Server -ErrorAction SilentlyContinue | Out-Null
    } else {
        Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
    }

    if (-not (Test-Path "C:\inetpub\wwwroot")) {
        New-Item -Path "C:\inetpub\wwwroot" -ItemType Directory -Force | Out-Null
    }

    $HtmlContent | Out-File "C:\inetpub\wwwroot\index.html" -Force -Encoding UTF8
    Start-Service W3SVC -ErrorAction SilentlyContinue
    Set-Service W3SVC -StartupType Automatic
    $IIS = $true
} catch {
    Write-Error "IIS setup failed: $_"
    $IIS = $false
}

# ============================================
# Install Chrome
# ============================================
try {
    $ChromePath = "C:\Temp\chrome_installer.exe"
    New-Item C:\Temp -ItemType Directory -Force | Out-Null
    Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $ChromePath
    Start-Process $ChromePath -ArgumentList "/silent /install" -Wait
    $Chrome = $true
} catch {
    Write-Error "Chrome install failed: $_"
    $Chrome = $false
}

# ============================================
# Install VS Code (System-wide, with shortcuts + PATH)
# ============================================
try {
    $VSCodeInstallerURL = "https://update.code.visualstudio.com/latest/win32-x64-system/stable"
    $InstallerPath = "$env:TEMP\VSCodeSetup.exe"
    Write-Host "Downloading VS Code stable installer..."
    Invoke-WebRequest -Uri $VSCodeInstallerURL -OutFile $InstallerPath -UseBasicParsing
    Write-Host "Installing VS Code silently..."
    Start-Process -FilePath $InstallerPath -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode,desktopicon,addtopath" -Wait
    $VSCode = $true
} catch {
    Write-Error "VS Code install failed: $_"
    $VSCode = $false
}

# ============================================
# Create Logon Script for Extensions
# ============================================
try {
    $Extensions = @("ms-python.python","ms-vscode.powershell","ms-toolsai.jupyter")
    $LogonScriptPath = "C:\ProgramData\VSCode-InstallExtensions.ps1"

    $ExtensionScript = @"
# Auto-install VS Code extensions for the logged-in user
\$extensions = @("ms-python.python","ms-vscode.powershell","ms-toolsai.jupyter")
foreach (\$ext in \$extensions) {
    try {
        code --install-extension \$ext --force
    } catch {
        Write-Output "Failed to install extension: \$ext"
    }
}
"@

    Set-Content -Path $LogonScriptPath -Value $ExtensionScript -Encoding UTF8

    $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$LogonScriptPath`""
    $Trigger = New-ScheduledTaskTrigger -AtLogOn
    $Principal = New-ScheduledTaskPrincipal -GroupId "Users" -RunLevel Limited
    Register-ScheduledTask -TaskName "VSCodeInstallExtensions" -Action $Action -Trigger $Trigger -Principal $Principal -Force
    $TaskCreated = $true
} catch {
    Write-Error "Extension setup failed: $_"
    $TaskCreated = $false
}

# ============================================
# Final Status Output
# ============================================
@{
    IIS        = $IIS
    Chrome     = $Chrome
    VSCode     = $VSCode
    LogonTask  = $TaskCreated
    IISData    = "Beautiful Page Deployed"
    Status     = "CSE Completed"
} | ConvertTo-Json | Out-File "$OutDir\cse_status.json" -Force

Stop-Transcript
Write-Host "===== CSE Script Completed ====="
exit 0