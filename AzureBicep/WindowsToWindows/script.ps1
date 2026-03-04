Write-Output "Starting Hyper-V and SMB setup..."

# -----------------------------
# 1. Install Hyper-V
# -----------------------------
Write-Output "Installing Hyper-V role..."
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart:$false

# -----------------------------
# 2. Create Shared Folder
# -----------------------------
$sharedPath = "C:\Shared"

if (!(Test-Path $sharedPath)) {
    New-Item -Path $sharedPath -ItemType Directory
    Write-Output "Created folder C:\Shared"
} else {
    Write-Output "C:\Shared already exists"
}

# -----------------------------
# 3. Set NTFS Permissions
# -----------------------------
Write-Output "Setting folder permissions..."
$acl = Get-Acl $sharedPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Everyone",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)
$acl.SetAccessRule($rule)
Set-Acl $sharedPath $acl

# -----------------------------
# 4. Enable SMB Share
# -----------------------------
Write-Output "Creating SMB share..."
if (!(Get-SmbShare -Name "SharedFolder" -ErrorAction SilentlyContinue)) {
    New-SmbShare -Name "SharedFolder" -Path $sharedPath -FullAccess "Everyone"
    Write-Output "SMB Share Created: \\$env:COMPUTERNAME\SharedFolder"
} else {
    Write-Output "SMB Share already exists"
}

# -----------------------------
# 5. Enable Firewall Rules for SMB
# -----------------------------
Write-Output "Enabling SMB firewall rules..."
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# -----------------------------
# 6. Verification File
# -----------------------------
New-Item -Path "$sharedPath\OuterVM_Verified.txt" -ItemType File -Force

Write-Output "Setup Completed Successfully."
Write-Output "Hyper-V installed and SMB share enabled."
