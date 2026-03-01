$ErrorActionPreference = "Stop"

$basePath = "C:\NestedLab"
$isoFolder = "$basePath\ISO"
$vmFolder = "$basePath\VMs"
$vmName = "NestedGuest"
$vhdPath = "$vmFolder\$vmName.vhdx"
$isoPath = "$isoFolder\WinServer2022.iso"

New-Item -ItemType Directory -Path $isoFolder -Force | Out-Null
New-Item -ItemType Directory -Path $vmFolder -Force | Out-Null

# Download Windows Server 2022 Evaluation ISO
if (!(Test-Path $isoPath)) {
    Write-Host "Downloading Windows Server 2022 ISO..."
    Invoke-WebRequest `
        -Uri "https://software-download.microsoft.com/pr/Windows_Server_2022_EVAL_x64FRE_en-us.iso" `
        -OutFile $isoPath
}

# Create Virtual Switch if not exists
if (-not (Get-VMSwitch -Name "NestedSwitch" -ErrorAction SilentlyContinue)) {
    New-VMSwitch -Name "NestedSwitch" -SwitchType Internal
}

# Remove VM if exists
if (Get-VM -Name $vmName -ErrorAction SilentlyContinue) {
    Stop-VM $vmName -Force
    Remove-VM $vmName -Force
}

# Create VHD
New-VHD -Path $vhdPath -SizeBytes 60GB -Dynamic

# Create VM
New-VM -Name $vmName `
       -MemoryStartupBytes 4GB `
       -Generation 2 `
       -VHDPath $vhdPath `
       -SwitchName "NestedSwitch"

Set-VMProcessor -VMName $vmName -Count 2
Set-VMDvdDrive -VMName $vmName -Path $isoPath
Set-VMFirmware -VMName $vmName -FirstBootDevice (Get-VMDvdDrive -VMName $vmName)

Start-VM $vmName

Write-Host "Nested VM started successfully."