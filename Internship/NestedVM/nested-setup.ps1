# ===============================
# Nested Virtualization Setup
# Enterprise Production Script
# ===============================

$BasePath  = "C:\NestedSetup"
$PhaseFile = "$BasePath\phase.txt"
$Complete  = "$BasePath\complete.flag"
$LogFile   = "$BasePath\install.log"

New-Item -ItemType Directory -Force -Path $BasePath | Out-Null
Start-Transcript -Path $LogFile -Append

function Set-Phase($value) {
    $value | Out-File $PhaseFile -Force
}

function Get-Phase {
    if (Test-Path $PhaseFile) {
        return Get-Content $PhaseFile
    }
    return "none"
}

try {

    if (Test-Path $Complete) {
        Write-Output "Configuration already completed."
        exit 0
    }

    $phase = Get-Phase

    # ======================
    # PHASE 1 – Install Hyper-V
    # ======================
    if ($phase -eq "none") {

        Write-Output "Phase 1: Installing Hyper-V"

        $hv = Get-WindowsFeature -Name Hyper-V

        if ($hv.InstallState -ne "Installed") {

            Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart:$false

            Set-Phase "postreboot"

            Register-ScheduledTask `
                -TaskName "NestedSetupPhase2" `
                -Trigger (New-ScheduledTaskTrigger -AtStartup) `
                -Action (New-ScheduledTaskAction `
                    -Execute "powershell.exe" `
                    -Argument "-ExecutionPolicy Bypass -File C:\NestedSetup\nested-setup.ps1") `
                -RunLevel Highest `
                -Force

            Restart-Computer -Force
        }
        else {
            Set-Phase "postreboot"
        }

        exit 0
    }

    # ======================
    # PHASE 2 – Configure Environment
    # ======================
    if ($phase -eq "postreboot") {

        Write-Output "Phase 2: Configuring Hyper-V Environment"

        # Ensure Data Disk exists
        $disk = Get-Disk | Where PartitionStyle -Eq "RAW" | Select -First 1
        if ($disk) {
            Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru |
                New-Partition -UseMaximumSize -AssignDriveLetter |
                Format-Volume -FileSystem NTFS -Confirm:$false
        }

        $dataDrive = (Get-Volume | Where DriveType -EQ "Fixed" | Where DriveLetter -ne "C").DriveLetter

        if (-not $dataDrive) {
            throw "No data disk found."
        }

        $root = "$($dataDrive):\Nested"

        if (!(Test-Path $root)) {
            New-Item -ItemType Directory -Path $root
        }

        # Create Switch
        if (-not (Get-VMSwitch -Name "InternalSwitch" -ErrorAction SilentlyContinue)) {
            New-VMSwitch -Name "InternalSwitch" -SwitchType Internal
            Start-Sleep -Seconds 10
        }

        $adapter = Get-NetAdapter | Where Name -Like "*InternalSwitch*"

        if (-not (Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -ErrorAction SilentlyContinue)) {
            New-NetIPAddress `
                -IPAddress 192.168.100.1 `
                -PrefixLength 24 `
                -InterfaceIndex $adapter.ifIndex
        }

        if (-not (Get-NetNat -Name "InnerNAT" -ErrorAction SilentlyContinue)) {
            New-NetNat `
                -Name "InnerNAT" `
                -InternalIPInterfaceAddressPrefix 192.168.100.0/24
        }

        # SMB Log Share
        $logPath = "$root\Logs"

        if (!(Test-Path $logPath)) {
            New-Item -ItemType Directory -Path $logPath
        }

        if (-not (Get-SmbShare -Name "InnerLogs" -ErrorAction SilentlyContinue)) {
            New-SmbShare `
                -Name "InnerLogs" `
                -Path $logPath `
                -FullAccess "Administrator"
        }

        # Create Inner VM
        if (-not (Get-VM -Name "InnerVM" -ErrorAction SilentlyContinue)) {

            $vmPath = "$root\VMs"
            New-Item -ItemType Directory -Force -Path $vmPath

            New-VM `
                -Name "InnerVM" `
                -MemoryStartupBytes 4GB `
                -Generation 2 `
                -NewVHDPath "$vmPath\InnerVM.vhdx" `
                -NewVHDSizeBytes 60GB `
                -SwitchName "InternalSwitch"

            Set-VMProcessor -VMName "InnerVM" -Count 2
        }

        Unregister-ScheduledTask -TaskName "NestedSetupPhase2" -Confirm:$false -ErrorAction SilentlyContinue

        New-Item -Path $Complete -ItemType File -Force
        Write-Output "Nested virtualization fully configured."

        exit 0
    }

}
catch {
    Write-Output $_
    exit 1
}
finally {
    Stop-Transcript
}
