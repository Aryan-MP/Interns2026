## Custom data script to install google chrome + IIS
$InstallIIS    = $true
$InstallChrome = $true
$IISData       = "this is me"

# ==============================
# INSTALL IIS (Windows 11)
# ==============================
if ($InstallIIS) {
    dism /online /enable-feature /featurename:IIS-WebServerRole /all /norestart
    iisreset

    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>IIS Page is Running - Danish</title>
</head>
<body>
    <h1>$IISData</h1>
</body>
</html>
"@

    $html | Out-File "C:\inetpub\wwwroot\index.html" -Encoding utf8 -Force
}

# ==============================
# INSTALL GOOGLE CHROME
# ==============================
if ($InstallChrome) {
    $TempPath = "C:\Temp"
    New-Item -ItemType Directory -Path $TempPath -Force | Out-Null

    $ChromeInstaller = "$TempPath\chrome.exe"
    Invoke-WebRequest `
        -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" `
        -OutFile $ChromeInstaller

    Start-Process $ChromeInstaller -ArgumentList "/silent /install" -Wait
}

