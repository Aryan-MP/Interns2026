$OutDir = "C:\CSE"
New-Item $OutDir -ItemType Directory -Force | Out-Null

# Beautiful Vibrant HTML Content
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
        .container {
            margin-top: 15%;
        }
        h1 {
            font-size: 48px;
            animation: glow 2s infinite alternate;
        }
        p {
            font-size: 22px;
        }
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
        .btn:hover {
            background-color: #ff5722;
            transform: scale(1.1);
        }
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

# IIS (Server OS)
if (Get-Command Install-WindowsFeature -ErrorAction SilentlyContinue) {
    Install-WindowsFeature Web-Server -ErrorAction SilentlyContinue | Out-Null
    $HtmlContent | Out-File C:\inetpub\wwwroot\index.html -Force -Encoding UTF8
    $IIS = $true
} else {
    # IIS (Client OS)
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
    $HtmlContent | Out-File C:\inetpub\wwwroot\index.html -Force -Encoding UTF8
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
    Chrome  = $Chrome
    IISData = "Beautiful Page Deployed"
} | ConvertTo-Json | Out-File "$OutDir\cse_status.json" -Force
