# ============================================
# Azure Custom Script Extension – FINAL
# ============================================

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# Logging
$logPath = "C:\Temp\extension.log"
New-Item -ItemType Directory -Force -Path C:\Temp | Out-Null
"$(Get-Date): Script started" | Out-File $logPath -Append

$customDataPath = "C:\AzureData\CustomData.bin"

if (!(Test-Path $customDataPath)) {
    "CustomData.bin not found. Exiting." | Out-File $logPath -Append
    exit 0
}

# ---- SAFE CUSTOM DATA READ (NO BASE64 CRASH) ----
try {
    $bytes = [System.IO.File]::ReadAllBytes($customDataPath)

    try {
        # Try Base64 decode
        $decodedText = [System.Text.Encoding]::UTF8.GetString(
            [System.Convert]::FromBase64String(
                [System.Text.Encoding]::UTF8.GetString($bytes).Trim()
            )
        )
        "Custom data decoded as Base64" | Out-File $logPath -Append
    }
    catch {
        # Fallback: treat as plain text
        $decodedText = [System.Text.Encoding]::UTF8.GetString($bytes)
        "Custom data treated as plain text" | Out-File $logPath -Append
    }
}
catch {
    "Failed to read custom data. Exiting." | Out-File $logPath -Append
    exit 0
}

# ---- PARSE key=value ----
$config = @{}
$decodedText -split "`n" | ForEach-Object {
    if ($_ -match "=") {
        $k, $v = $_ -split "=", 2
        $config[$k.Trim()] = $v.Trim().ToLower()
    }
}

# ---- IIS ----
if ($config["install_iis"] -eq "true") {
    Install-WindowsFeature Web-Server -IncludeManagementTools | Out-Null
    "IIS install attempted" | Out-File $logPath -Append

    if ($config.ContainsKey("iis_data")) {
        $html = "<html><body style='font-family:Arial'><h1>$($config["iis_data"])</h1></body></html>"
        $html | Out-File "C:\inetpub\wwwroot\index.html" -Encoding utf8 -Force
        "IIS page updated" | Out-File $logPath -Append
    }
}

# ---- CHROME ----
if ($config["install_chrome"] -eq "true") {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $installer = "C:\Temp\chrome.exe"
    Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $installer -UseBasicParsing
    Start-Process $installer -ArgumentList "/silent /install" -Wait
    "Chrome install attempted" | Out-File $logPath -Append
}

"$(Get-Date): Script completed successfully" | Out-File $logPath -Append
exit 0
