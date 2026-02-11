$InstallIIS = $true
$InstallChrome = $true
$IISData = "Azure VM Demo - Danish"

if ($InstallIIS) {
    dism /online /enable-feature /featurename:IIS-WebServerRole /all /norestart
    iisreset

$html = @"
<!DOCTYPE html>
<html>
<head>
<title>Azure IIS Demo</title>
<style>
body { font-family: Arial; background:#0f2027; color:white; text-align:center; padding-top:60px; }
.card { background:#203a43; padding:30px; border-radius:12px; width:500px; margin:auto; }
</style>
</head>
<body>
<div class="card">
<h1>IIS Installed</h1>
<p>$IISData</p>
<p>Custom Script Extension Success</p>
</div>
</body>
</html>
"@

$html | Out-File "C:\inetpub\wwwroot\index.html" -Encoding utf8 -Force
}

if ($InstallChrome) {
    $path = "C:\Temp"
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    $installer = "$path\chrome.exe"

    Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $installer
    Start-Process $installer -ArgumentList "/silent /install" -Wait
}
