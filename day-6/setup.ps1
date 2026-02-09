# -------------------------------
# Configuration (what to install)
# -------------------------------
$InstallTerraform = $true
$TerraformVersion = "1.6.6"
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

# -------------------------------
# Install Terraform
# -------------------------------
if ($InstallTerraform) {
    $terraformUrl = "https://releases.hashicorp.com/terraform/$TerraformVersion/terraform_${TerraformVersion}_windows_amd64.zip"
    $zipPath = "$env:TEMP\terraform.zip"
    $installPath = "C:\Terraform"

    Invoke-WebRequest $terraformUrl -OutFile $zipPath
    Expand-Archive $zipPath -DestinationPath $installPath -Force
    setx PATH "$env:PATH;$installPath" /M
}