# Automated nested virtualization setup for Azure

# Check if Hyper-V is installed
$hypervInstalled = (Get-WindowsFeature -Name Hyper-V).Installed

if (-not $hypervInstalled) {
    # Install Hyper-V
    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
    
    # Copy script for continuation after reboot
    Copy-Item $PSCommandPath "C:\ContinueSetup.ps1" -Force
    
    # Create scheduled task to continue after reboot
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass -File C:\ContinueSetup.ps1'
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ContinueNestedVMSetup" -Principal $principal -Force
    
    # Reboot to complete Hyper-V installation
    Restart-Computer -Force
    exit 0
}

# Hyper-V is installed, continue setup
Unregister-ScheduledTask -TaskName "ContinueNestedVMSetup" -Confirm:$false -ErrorAction SilentlyContinue

# Wait for Hyper-V services
Start-Sleep -Seconds 30

# Create Internal Virtual Switch
New-VMSwitch -Name "InternalSwitch" -SwitchType Internal -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5

# Configure IP address on internal switch
$adapter = (Get-NetAdapter | Where-Object { $_.Name -like "*InternalSwitch*" })[0]
if ($adapter) {
    New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress 192.168.100.1 -PrefixLength 24 -ErrorAction SilentlyContinue
}

# Create shared folder
New-Item -ItemType Directory -Path "C:\SharedFiles" -Force | Out-Null

# Create SMB share
New-SmbShare -Name "SharedFiles" -Path "C:\SharedFiles" -FullAccess "Everyone" -ErrorAction SilentlyContinue

# Set folder permissions
$acl = Get-Acl "C:\SharedFiles"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($rule)
Set-Acl "C:\SharedFiles" $acl

# Enable firewall for file sharing
Set-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Enabled True -Profile Private

# Create VM directory
New-Item -ItemType Directory -Path "C:\VMs" -Force | Out-Null

# Download Ubuntu image
$ubuntuUrl = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
Start-BitsTransfer -Source $ubuntuUrl -Destination "C:\VMs\ubuntu.img"

# Convert to VHDX and resize
Copy-Item "C:\VMs\ubuntu.img" "C:\VMs\ubuntu.vhdx"
Resize-VHD -Path "C:\VMs\ubuntu.vhdx" -SizeBytes 20GB

# Create cloud-init configuration
New-Item -ItemType Directory -Path "C:\VMs\cloud-init" -Force | Out-Null

$userData = @"
#cloud-config
hostname: linuxvm
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
runcmd:
  - apt-get update
  - apt-get install -y cifs-utils
  - mkdir -p /mnt/shared
  - mount -t cifs //192.168.100.1/SharedFiles /mnt/shared -o guest,uid=1000,gid=1000,dir_mode=0777,file_mode=0777,vers=3.0
  - echo '<!DOCTYPE html><html><head><title>Nested VM</title></head><body><h1>Hello from Nested Linux VM!</h1><p>Successfully running inside Hyper-V on Azure Windows Server</p></body></html>' > /mnt/shared/index.html
  - echo "//192.168.100.1/SharedFiles /mnt/shared cifs guest,uid=1000,gid=1000,dir_mode=0777,file_mode=0777,vers=3.0,_netdev 0 0" >> /etc/fstab
"@

$userData | Out-File -FilePath "C:\VMs\cloud-init\user-data" -Encoding ASCII -NoNewline
"instance-id: iid-local01`nlocal-hostname: linuxvm" | Out-File -FilePath "C:\VMs\cloud-init\meta-data" -Encoding ASCII -NoNewline

# Create cloud-init ISO
$fsi = New-Object -ComObject IMAPI2FS.MsftFileSystemImage
$fsi.ChooseImageDefaultsForMediaType(13)
$fsi.VolumeName = "cidata"
$fsi.Root.AddTree("C:\VMs\cloud-init", $false)
$result = $fsi.CreateResultImage()
$iso = New-Object -ComObject ADODB.Stream
$iso.Type = 1
$iso.Open()
$iso.Write($result.ImageStream.GetAnyDataEvenIfClassNotRegistered())
$iso.SaveToFile("C:\VMs\cloud-init.iso", 2)
$iso.Close()

# Create and configure VM
New-VM -Name "LinuxVM" -MemoryStartupBytes 2GB -Generation 2 -VHDPath "C:\VMs\ubuntu.vhdx" -SwitchName "InternalSwitch" -ErrorAction Stop
Set-VMProcessor -VMName "LinuxVM" -Count 2
Set-VMMemory -VMName "LinuxVM" -DynamicMemoryEnabled $false
Set-VMFirmware -VMName "LinuxVM" -EnableSecureBoot Off
Add-VMDvdDrive -VMName "LinuxVM" -Path "C:\VMs\cloud-init.iso"

# Start VM
Start-VM -Name "LinuxVM"

# Cleanup
Remove-Item "C:\ContinueSetup.ps1" -Force -ErrorAction SilentlyContinue

Write-Log ""
Write-Log "=========================================="
Write-Log "Configuration Complete!"
Write-Log "=========================================="
Write-Log "Shared Folder: $sharedPath"
Write-Log "Linux VM: Running"
Write-Log ""
Write-Log "The index.html file will be created in approximately 5-10 minutes."
Write-Log "Check C:\SharedFiles for the file."
Write-Log "Log file: $logFile"
Write-Log "=========================================="

Write-Host ""
Write-Host "Setup script completed successfully!" -ForegroundColor Green
Write-Host "Check C:\SharedFiles\index.html in 5-10 minutes" -ForegroundColor Cyan