# Ensure script runs with admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Error "Please run this script as Administrator."
    exit 1
}

# --- Setup paths ---
$scriptFolder = "C:\Scripts"
$scriptPath   = "$scriptFolder\logonscript3.ps1"
$logFile      = "$scriptFolder\InstallApps.log"

# Ensure folder exists
if (-not (Test-Path $scriptFolder)) {
    New-Item -ItemType Directory -Path $scriptFolder | Out-Null
}

# Copy this script into C:\Scripts if not already there
$currentScript = $MyInvocation.MyCommand.Definition
if ($currentScript -ne $scriptPath) {
    Copy-Item $currentScript $scriptPath -Force
}

# Logging function
function Log($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $msg" | Out-File -FilePath $logFile -Append
    Write-Output $msg
}

Log "Starting logonscript3.ps1..."

# --- Install Google Chrome ---
Log "Installing Google Chrome..."
$chromeInstaller = "$env:TEMP\chrome_installer.exe"
Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $chromeInstaller
Start-Process -FilePath $chromeInstaller -Args "/silent /install" -Wait
Remove-Item $chromeInstaller -Force
Log "Google Chrome installed."

# --- Install Visual Studio Code ---
Log "Installing Visual Studio Code..."
$vscodeInstaller = "$env:TEMP\vscode_installer.exe"
Invoke-WebRequest -Uri "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -OutFile $vscodeInstaller
Start-Process -FilePath $vscodeInstaller -Args "/silent /mergetasks=!runcode" -Wait
Remove-Item $vscodeInstaller -Force
Log "Visual Studio Code installed."

# --- Install VS Code Extensions ---
Log "Installing VS Code extensions..."
$codePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"

if (-Not (Test-Path $codePath)) {
    Log "ERROR: VS Code not found at $codePath"
    exit 1
}

$extensions = @(
    "ms-python.python",
    "ms-vscode.powershell",
    "ms-azuretools.vscode-docker"
)

foreach ($ext in $extensions) {
    Log "Installing extension: $ext"
    Start-Process -FilePath $codePath -ArgumentList "--install-extension $ext" -Wait -NoNewWindow
}
Log "VS Code extensions installed."

# --- Register Scheduled Task ---
Log "Registering scheduled task..."
$taskName = "InstallApps"

# Remove existing task if it already exists
schtasks /delete /tn $taskName /f | Out-Null

# Create new scheduled task under logontaskvm account
schtasks /create /tn $taskName `
    /tr "powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`"" `
    /sc onlogon /rl highest /ru logontaskvm | Out-Null

Log "Scheduled task '$taskName' created successfully."
Log "logonscript3.ps1 completed."
