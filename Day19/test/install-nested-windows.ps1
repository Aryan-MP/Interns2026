# =========================================================
# Azure Nested Hyper-V Full Automation Script
# Safe for Custom Script Extension
# VM Size: Standard_D4s_v3
# OS: Windows Server 2019/2022 Datacenter
# =========================================================

$ErrorActionPreference = "Stop"

# =========================================================
# PHASE 1 – Install Hyper-V if not installed
# =========================================================
$hv = Get-WindowsFeature -Name Hyper-V

if ($hv.InstallState -ne "Installed") {

    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

    # Create folder
    New-Item -Path "C:\NestedLab" -ItemType Directory -Force

    # Create continuation script (Phase 2)
@'
# =========================================================
# PHASE 2 – Create Nested Windows VM
# =========================================================

$ErrorActionPreference = "Stop"

# Create folders
New-Item -Path "C:\NestedLab\ISO" -ItemType Directory -Force
New-Item -Path "C:\NestedLab\VMs" -ItemType Directory -Force

# Download Windows Server 2022 Eval ISO
$isoUrl  = "https://software-download.microsoft.com/download/pr/Windows_Server_2022_Datacenter_EVAL_en-us.iso"
$isoPath = "C:\NestedLab\ISO\WinServer2022.iso"

Start-BitsTransfer -Source $isoUrl -Destination $isoPath

# Mount ISO
Mount-DiskImage -ImagePath $isoPath
$driveLetter = (Get-DiskImage $isoPath | Get-Volume).DriveLetter
$wimPath = "$driveLetter`:\sources\install.wim"

# Create VHD
$VHDPath = "C:\NestedLab\VMs\NestedWindows.vhdx"
New-VHD -Path $VHDPath -SizeBytes 60GB -Dynamic | Out-Null
Mount-VHD $VHDPath

$disk = Get-Disk | Where-Object PartitionStyle -eq "RAW"
Initialize-Disk $disk.Number -PartitionStyle GPT
$partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
Format-Volume -Partition $partition -FileSystem NTFS -Confirm:$false | Out-Null

$targetDrive = ($partition | Get-Volume).DriveLetter

# Apply Windows Image
dism /Apply-Image /ImageFile:$wimPath /Index:1 /ApplyDir:$targetDrive`:\
bcdboot $targetDrive`:\Windows

Dismount-VHD $VHDPath
Dismount-DiskImage $isoPath

# Create NAT Switch
New-VMSwitch -Name "NATSwitch" -SwitchType Internal

$ifIndex = (Get-NetAdapter | Where-Object Name -like "*NATSwitch*").ifIndex

New-NetIPAddress -IPAddress 192.168.100.1 `
                 -PrefixLength 24 `
                 -InterfaceIndex $ifIndex

New-NetNat -Name "NestedNAT" `
           -InternalIPInterfaceAddressPrefix 192.168.100.0/24

# Create VM
New-VM -Name "NestedWindowsVM" `
       -MemoryStartupBytes 4GB `
       -VHDPath $VHDPath `
       -Generation 2 `
       -SwitchName "NATSwitch"

Set-VMProcessor -VMName "NestedWindowsVM" -Count 2

Start-VM -Name "NestedWindowsVM"

# Remove scheduled task after completion
Unregister-ScheduledTask -TaskName "ContinueNestedSetup" -Confirm:$false
'@ | Out-File "C:\NestedLab\Continue.ps1" -Encoding UTF8

    # Register scheduled task
    $action = New-ScheduledTaskAction `
        -Execute "PowerShell.exe" `
        -Argument "-ExecutionPolicy Bypass -File C:\NestedLab\Continue.ps1"

    $trigger = New-ScheduledTaskTrigger -AtStartup

    Register-ScheduledTask `
        -TaskName "ContinueNestedSetup" `
        -Action $action `
        -Trigger $trigger `
        -User "SYSTEM" `
        -RunLevel Highest `
        -Force

    Restart-Computer -Force
}

# =========================================================
# END
# =========================================================