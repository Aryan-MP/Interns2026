# Day Tasks Documentation

## Task 1: Creating the Virtual Machine Scale Set (VMSS)

### Step 1: Create the Base Virtual Machine
- Create a Virtual Machine with all required configurations such as:
  - OS (Windows or Linux)
  - VM size
  - Networking (VNet, Subnet, NSG)
  - Required software installations
- This VM will act as the *base VM* for image creation.

---

### Step 2: Create an Image from the VM
- Stop the VM.
- Decide the image type:
  - *Specialized Image*: Keeps machine-specific data.
  - *Generalized Image*: Removes machine-specific data (recommended for scale sets).
- Create the image from the VM using Azure Portal / CLI.

---

### Step 3: Create Virtual Machine Scale Set from the Image
- Create a *Virtual Machine Scale Set* using the created image.
- Enable *automatic scaling*.
- Configure:
  - Minimum instance count
  - Maximum instance count
  - Default (desired) instance count

  <img src=".\Images\Screenshot 2026-02-09 151500.png" alt="VMSS overview page">


---

### Step 4: Trigger Autoscaling Using Stress Tool
- Connect to one of the VM instances.
- Install the stress tool.
- Run stress command to increase CPU utilization.
- Once CPU crosses the configured threshold:
  - Azure automatically increases VM instances by 1.
- Observe scaling behavior from Azure Portal.
- I have given minimum as 2 VM's but after using the stress command the VM's count to 3.
<img src=".\Images\Screenshot 2026-02-09 151207.png" alt="">


------


## Task 2: Installing IIS on Windows VM Using Custom Data and Custom Script Extension

### Step 1: Create Windows VM with Custom Data
- Create a Windows Virtual Machine with required specifications.
- Add PowerShell commands in the *Custom Data* section.
- Custom Data is executed *only once during VM provisioning*.

---

### Step 2: Create Storage Account and Upload Script
- Create a Storage Account.
- Create a container inside the Storage Account.
- Upload the PowerShell script that installs IIS and Chrome.

---

### Step 3: Execute Script Using Custom Script Extension (CSE)

Below is the PowerShell script used for IIS and Chrome installation:

powershell
param (
    [bool]$InstallIIS = $true,
    [bool]$InstallChrome = $true,
    [string]$IISMessage = "Hello from IIS"
)

$OS = (Get-CimInstance Win32_OperatingSystem).Caption

if ($InstallIIS) {
    if ($OS -like "*Server*") {
        Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    } else {
        Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All -NoRestart
    }

    Start-Service W3SVC
    Set-Service W3SVC -StartupType Automatic

    $html = @"
<html>
<body>
<h1>$IISMessage</h1>
<p>IIS is running successfully</p>
</body>
</html>
"@

    $html | Out-File "C:\inetpub\wwwroot\index.html" -Encoding UTF8
}

if ($InstallChrome) {
    $ChromeInstaller = "$env:TEMP\chrome_installer.exe"
    $ChromeURL = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"

    Invoke-WebRequest -Uri $ChromeURL -OutFile $ChromeInstaller
    Start-Process -FilePath $ChromeInstaller -ArgumentList "/silent /install" -Wait
    Remove-Item $ChromeInstaller -Force
}

exit 0


- After execution, the script can be found at:

C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\<Version>\Downloads\<n>\

<img src=".\Images\Day-6\Screenshot 2026-02-09 174638.png">
---

### Step 4: Verify Custom Data Location
- The Custom Data content is stored in:

C:\AzureData\CustomData.bin

- This file contains Base64-encoded custom data.

<img src=".\Images\Day-6\Screenshot 2026-02-09 174550.png">

---

### Step 5: Access IIS Using Public IP
- Once IIS is installed and the message is written:
- Access the application using:

http://<VM-PUBLIC-IP>

- The IIS page displays the custom message configured in Custom Data.

<img src=".\Images\Day-6\Screenshot 2026-02-09 174935.png">

---
