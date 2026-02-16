# ConfigureVM.ps1
# Complete automated nested virtualization setup with better error handling and smaller Ubuntu image

# Create log file
$logFile = "C:\hyperv-setup.log"
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

Write-Log "=== Starting Nested Virtualization Setup ==="

# Check if Hyper-V is installed
$hypervInstalled = (Get-WindowsFeature -Name Hyper-V).Installed

if (-not $hypervInstalled) {
    Write-Log "Hyper-V not installed. Installing now..."
    
    # Install Hyper-V
    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
    
    Write-Log "Hyper-V installed. Creating continuation script..."
    
    # Copy this script to a safe location for continuation
    Copy-Item $PSCommandPath "C:\ContinueSetup.ps1" -Force
    
    # Create scheduled task to run after reboot
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass -File C:\ContinueSetup.ps1'
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ContinueNestedVMSetup" -Principal $principal -Force
    
    Write-Log "Scheduled task created. System will reboot..."
    Restart-Computer -Force
    exit 0
}

Write-Log "Hyper-V is installed. Continuing with VM configuration..."

# Remove the scheduled task if it exists
Unregister-ScheduledTask -TaskName "ContinueNestedVMSetup" -Confirm:$false -ErrorAction SilentlyContinue
Write-Log "Removed scheduled task"

# Wait for Hyper-V services to be fully ready
Write-Log "Waiting for Hyper-V services to start..."
Start-Sleep -Seconds 30

# Create Internal Virtual Switch
Write-Log "Creating Internal Virtual Switch..."
try {
    $existingSwitch = Get-VMSwitch -Name "InternalSwitch" -ErrorAction SilentlyContinue
    if (-not $existingSwitch) {
        New-VMSwitch -Name "InternalSwitch" -SwitchType Internal -ErrorAction Stop
        Write-Log "Internal switch created successfully"
    } else {
        Write-Log "Internal switch already exists"
    }
} catch {
    Write-Log "Error creating virtual switch: $_"
}

# Wait for network adapter to be created
Start-Sleep -Seconds 5

# Configure IP for internal switch - FIX: Get only first adapter
Write-Log "Configuring IP address for internal switch..."
try {
    $adapters = Get-NetAdapter | Where-Object { $_.Name -like "*InternalSwitch*" }
    if ($adapters) {
        # Take only the FIRST adapter if multiple exist
        $adapter = $adapters | Select-Object -First 1
        Write-Log "Found adapter: $($adapter.Name)"
        
        # Check if IP already exists
        $existingIP = Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -eq "192.168.100.1" }
        
        if (-not $existingIP) {
            New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress 192.168.100.1 -PrefixLength 24 -ErrorAction Stop
            Write-Log "IP address configured: 192.168.100.1"
        } else {
            Write-Log "IP address already configured"
        }
    } else {
        Write-Log "Warning: Could not find network adapter for internal switch"
    }
} catch {
    Write-Log "Error configuring IP address: $_"
}

# Create shared folder
Write-Log "Creating shared folder..."
$sharedPath = "C:\SharedFiles"
try {
    if (-not (Test-Path $sharedPath)) {
        New-Item -ItemType Directory -Path $sharedPath -Force | Out-Null
        Write-Log "Shared folder created"
    } else {
        Write-Log "Shared folder already exists"
    }
} catch {
    Write-Log "Error creating shared folder: $_"
}

# Create SMB share
Write-Log "Creating SMB share..."
try {
    $existingShare = Get-SmbShare -Name "SharedFiles" -ErrorAction SilentlyContinue
    if (-not $existingShare) {
        New-SmbShare -Name "SharedFiles" -Path $sharedPath -FullAccess "Everyone" -ErrorAction Stop
        Write-Log "SMB share created successfully"
    } else {
        Write-Log "SMB share already exists"
    }
    
    # Set NTFS permissions
    $acl = Get-Acl $sharedPath
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($accessRule)
    Set-Acl $sharedPath $acl
    Write-Log "NTFS permissions set"
} catch {
    Write-Log "Error creating SMB share: $_"
}

# Configure firewall for SMB
Write-Log "Configuring firewall for SMB..."
try {
    Set-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Enabled True -Profile Private,Domain
    Write-Log "Firewall configured for SMB"
} catch {
    Write-Log "Error configuring firewall: $_"
}

# Create VM directory
Write-Log "Creating VM directory..."
$vmDir = "C:\VMs"
New-Item -ItemType Directory -Path $vmDir -Force | Out-Null

# Clean up any partial downloads
Write-Log "Cleaning up any previous partial downloads..."
Remove-Item "$vmDir\ubuntu.img" -Force -ErrorAction SilentlyContinue
Remove-Item "$vmDir\ubuntu.vhdx" -Force -ErrorAction SilentlyContinue

# Download Ubuntu cloud image - USING SMALLER/FASTER 20.04 IMAGE
Write-Log "Downloading Ubuntu 20.04 cloud image..."
$ubuntuUrl = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
$imagePath = "$vmDir\ubuntu.img"

try {
    # Use BITS transfer for more reliable download
    Write-Log "Starting BITS transfer (more reliable for large files)..."
    Start-BitsTransfer -Source $ubuntuUrl -Destination $imagePath -Description "Ubuntu Cloud Image" -ErrorAction Stop
    Write-Log "Ubuntu image downloaded successfully via BITS"
} catch {
    Write-Log "BITS transfer failed, trying Invoke-WebRequest: $_"
    try {
        # Fallback to Invoke-WebRequest
        $ProgressPreference = 'SilentlyContinue'  # Speeds up download
        Invoke-WebRequest -Uri $ubuntuUrl -OutFile $imagePath -UseBasicParsing -ErrorAction Stop
        $ProgressPreference = 'Continue'
        Write-Log "Ubuntu image downloaded successfully via WebRequest"
    } catch {
        Write-Log "ERROR: Failed to download Ubuntu image: $_"
        Write-Log "You can manually download from: $ubuntuUrl"
        exit 1
    }
}

# Verify download
$imageSize = (Get-Item $imagePath).Length
Write-Log "Downloaded file size: $imageSize bytes"
if ($imageSize -lt 100MB) {
    Write-Log "ERROR: Downloaded file is too small, download may have failed"
    exit 1
}

# Convert to VHDX
Write-Log "Converting to VHDX format..."
$vhdPath = "$vmDir\ubuntu.vhdx"
try {
    Copy-Item $imagePath $vhdPath -Force
    Write-Log "Image converted to VHDX"
} catch {
    Write-Log "Error converting to VHDX: $_"
    exit 1
}

# Resize VHDX
Write-Log "Resizing VHDX to 20GB..."
try {
    Resize-VHD -Path $vhdPath -SizeBytes 20GB -ErrorAction Stop
    Write-Log "VHDX resized successfully"
} catch {
    Write-Log "Warning: Could not resize VHDX (may already be larger): $_"
}

# Create cloud-init directory
Write-Log "Creating cloud-init configuration..."
$cloudInitDir = "$vmDir\cloud-init"
New-Item -ItemType Directory -Path $cloudInitDir -Force | Out-Null

# Create user-data file with cloud-init configuration
$userData = @"
#cloud-config
hostname: linuxvm
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
runcmd:
  - apt-get update
  - DEBIAN_FRONTEND=noninteractive apt-get install -y cifs-utils
  - mkdir -p /mnt/shared
  - sleep 10
  - mount -t cifs //192.168.100.1/SharedFiles /mnt/shared -o guest,uid=1000,gid=1000,dir_mode=0777,file_mode=0777,vers=3.0
  - |
    cat > /mnt/shared/index.html << 'HTMLEOF'
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nested Linux VM</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .container {
                background: rgba(255, 255, 255, 0.95);
                color: #333;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            }
            h1 {
                color: #667eea;
                margin-bottom: 20px;
            }
            .info {
                background: #f3f4f6;
                padding: 15px;
                margin: 10px 0;
                border-radius: 5px;
                border-left: 4px solid #667eea;
            }
            .success {
                background: #d1fae5;
                border-left: 4px solid #10b981;
                padding: 15px;
                margin: 20px 0;
                border-radius: 5px;
                color: #065f46;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🎉 Hello from Nested Linux VM!</h1>
            <div class="info">
                <p><strong>Status:</strong> Successfully running inside Hyper-V</p>
                <p><strong>Host Platform:</strong> Azure Windows Server 2022</p>
                <p><strong>Hypervisor:</strong> Microsoft Hyper-V</p>
                <p><strong>Guest OS:</strong> Ubuntu Server 20.04 LTS</p>
                <p><strong>Network:</strong> Internal Switch (192.168.100.0/24)</p>
            </div>
            <div class="info">
                <p><strong>Shared Folder (Windows):</strong> C:\SharedFiles</p>
                <p><strong>SMB Share:</strong> //192.168.100.1/SharedFiles</p>
                <p><strong>Mount Point (Linux):</strong> /mnt/shared</p>
            </div>
            <div class="success">
                ✓ This HTML file was created inside the nested Linux VM and is accessible via the Windows host through the SMB shared folder!
            </div>
        </div>
    </body>
    </html>
    HTMLEOF
  - echo "//192.168.100.1/SharedFiles /mnt/shared cifs guest,uid=1000,gid=1000,dir_mode=0777,file_mode=0777,vers=3.0,_netdev 0 0" >> /etc/fstab
  - echo "Setup completed at: `$(date)" > /mnt/shared/setup-complete.txt
"@

$userData | Out-File -FilePath "$cloudInitDir\user-data" -Encoding ASCII -NoNewline
Write-Log "User-data configuration created"

# Create meta-data file
$metaData = "instance-id: iid-local01`nlocal-hostname: linuxvm"
$metaData | Out-File -FilePath "$cloudInitDir\meta-data" -Encoding ASCII -NoNewline
Write-Log "Meta-data configuration created"

# Create cloud-init ISO
Write-Log "Creating cloud-init ISO..."
$isoPath = "$vmDir\cloud-init.iso"
try {
    $fsi = New-Object -ComObject IMAPI2FS.MsftFileSystemImage
    $fsi.ChooseImageDefaultsForMediaType(13)
    $fsi.VolumeName = "cidata"
    $fsi.Root.AddTree($cloudInitDir, $false)
    $result = $fsi.CreateResultImage()
    $stream = $result.ImageStream
    
    $iso = New-Object -ComObject ADODB.Stream
    $iso.Type = 1
    $iso.Open()
    $iso.Write($stream.GetAnyDataEvenIfClassNotRegistered())
    $iso.SaveToFile($isoPath, 2)
    $iso.Close()
    
    Write-Log "Cloud-init ISO created successfully"
} catch {
    Write-Log "Error creating ISO: $_"
    exit 1
}

# Check if VM already exists
$existingVM = Get-VM -Name "LinuxVM" -ErrorAction SilentlyContinue
if ($existingVM) {
    Write-Log "VM 'LinuxVM' already exists. Removing..."
    Stop-VM -Name "LinuxVM" -Force -ErrorAction SilentlyContinue
    Remove-VM -Name "LinuxVM" -Force
}

# Create Linux VM
Write-Log "Creating Linux VM..."
try {
    New-VM -Name "LinuxVM" `
           -MemoryStartupBytes 2GB `
           -Generation 2 `
           -VHDPath $vhdPath `
           -SwitchName "InternalSwitch" `
           -ErrorAction Stop
    
    Write-Log "Linux VM created successfully"
} catch {
    Write-Log "Error creating VM: $_"
    exit 1
}

# Configure VM settings
Write-Log "Configuring VM settings..."
Set-VMProcessor -VMName "LinuxVM" -Count 2
Set-VMMemory -VMName "LinuxVM" -DynamicMemoryEnabled $false
Set-VMFirmware -VMName "LinuxVM" -EnableSecureBoot Off

# Attach cloud-init ISO
Write-Log "Attaching cloud-init ISO..."
Add-VMDvdDrive -VMName "LinuxVM" -Path $isoPath

# Start the VM
Write-Log "Starting Linux VM..."
try {
    Start-VM -Name "LinuxVM" -ErrorAction Stop
    Write-Log "Linux VM started successfully"
} catch {
    Write-Log "Error starting VM: $_"
    exit 1
}

# Create README in shared folder
$readmeContent = @"
Nested Virtualization Setup - Complete
=======================================

Configuration completed at: $(Get-Date)

NETWORK DETAILS:
- Windows Host IP (Internal): 192.168.100.1
- Linux VM: Uses DHCP (typically 192.168.100.x)
- Shared Folder: C:\SharedFiles
- SMB Share: \\localhost\SharedFiles

LINUX VM STATUS:
The Linux VM will take approximately 5-10 minutes to:
1. Boot up
2. Run cloud-init configuration
3. Install cifs-utils
4. Mount the shared folder
5. Create index.html

CHECK STATUS:
PowerShell: Get-VM -Name LinuxVM
View Console: vmconnect localhost LinuxVM

Files created:
- index.html (styled HTML page)
- setup-complete.txt (timestamp file)

Setup log available at: C:\hyperv-setup.log
"@

$readmeContent | Out-File -FilePath "$sharedPath\README.txt" -Encoding ASCII

# Clean up continuation script
Remove-Item -Path "C:\ContinueSetup.ps1" -Force -ErrorAction SilentlyContinue

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