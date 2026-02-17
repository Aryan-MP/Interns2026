# ============================================
# Azure Custom Script Extension – FINAL
# ============================================
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"
$logPath = "C:\Temp\extension.log"
New-Item -ItemType Directory -Force -Path C:\Temp | Out-Null
"$(Get-Date): Script started" | Out-File $logPath -Append
$customDataPath = "C:\AzureData\CustomData.bin"
if (!(Test-Path $customDataPath)) { "CustomData.bin not found. Exiting." | Out-File $logPath -Append; exit 0 }
try {
  $bytes = [System.IO.File]::ReadAllBytes($customDataPath)
  try {
    $decodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String([System.Text.Encoding]::UTF8.GetString($bytes).Trim()))
  }
  catch {
    $decodedText = [System.Text.Encoding]::UTF8.GetString($bytes)
  }
}
catch {
  "Failed to read custom data. Exiting." | Out-File $logPath -Append
  exit 0
}
$config = @{}
$decodedText -split "`n" | ForEach-Object {
  if ($_ -match "=") {
    $k, $v = $_ -split "=", 2
    $config[$k.Trim()] = $v.Trim().ToLower()
  }
}
if ($config["install_iis"] -eq "true") {
  Install-WindowsFeature Web-Server -IncludeManagementTools | Out-Null
  if ($config.ContainsKey("iis_data")) {
    $html = "<html><body style='font-family:Arial'><h1>$($config["iis_data"])</h1></body></html>"
    $html | Out-File "C:\inetpub\wwwroot\index.html" -Encoding utf8 -Force
  }
}
if ($config["install_chrome"] -eq "true") {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $installer = "C:\Temp\chrome.exe"
  Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $installer -UseBasicParsing
  Start-Process $installer -ArgumentList "/silent /install" -Wait
}
"$(Get-Date): Script completed successfully" | Out-File $logPath -Append
exit 0
