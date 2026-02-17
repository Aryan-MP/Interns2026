# -------------------------------
# Configuration (what to install)
# -------------------------------
$InstallIIS = $true
$IISMessage = "Hello World!"
$InstallChrome = $true

# -------------------------------
# Install IIS
# -------------------------------
if ($InstallIIS) {
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All

    $htmlPath = "C:\inetpub\wwwroot\index.html"
    "<h1>$IISMessage</h1>" | Out-File $htmlPath -Encoding utf8
}

# -------------------------------
# Install Google Chrome
# -------------------------------
if ($InstallChrome) {
    $chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    $chromeInstaller = "$env:TEMP\chrome_installer.exe"

    Invoke-WebRequest $chromeUrl -OutFile $chromeInstaller
    Start-Process $chromeInstaller -ArgumentList "/silent /install" -Wait
}


    Invoke-WebRequest $terraformUrl -OutFile $zipPath
    Expand-Archive $zipPath -DestinationPath $installPath -Force
    setx PATH "$env:PATH;$installPath" /M
}
