param(
[string]$storageAccount,
[string]$fileShare,
[string]$storageKey
)

Write-Host "=== Enabling Hyper-V ==="
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

Write-Host "=== Mounting Azure File Share ==="

$secureKey = ConvertTo-SecureString $storageKey -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("Azure$storageAccount",$secureKey)

New-PSDrive -Name Z -PSProvider FileSystem `  -Root "\\$storageAccount.file.core.windows.net\$fileShare"`
-Credential $cred -Persist

Write-Host "=== Running Hyper-V Task ==="
powershell -ExecutionPolicy Bypass -File hyperv-task.ps1
