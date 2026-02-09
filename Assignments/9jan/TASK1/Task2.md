# Azure Windows VM with IIS using Custom Data & Custom Script Extension

## 📘 Overview
This task demonstrates how to deploy a Windows Virtual Machine on Azure, automatically install and configure IIS, and deploy a web page using **Custom Data** and **Custom Script Extension**.

The objective is to understand:
- Windows Virtual Machines
- IIS Web Server
- Custom Data (User Data)
- Custom Script Extension
- Azure Storage (Blob Container)

---

## 🛠️ Services Used
- Azure Virtual Machine (Windows)
- IIS Web Server
- Azure Storage Account (Blob Container)
- Custom Data (User Data)
- Custom Script Extension
- Public IP Address

---

## 🧩 Task Implementation

### 1️⃣ Create a Windows Virtual Machine
- Created a **Windows VM**
- Assigned a **Public IP** to access the server
- Selected appropriate VM size
- Enabled Custom Data during VM creation

---

### 2️⃣ Configure Custom Data (User Data)
- Added custom user data during VM creation
- Example purpose:
  - Indicate IIS installation
  - Indicate Chrome installation
- This data is stored in the **Azure VM data directory** and is available during provisioning

> Custom Data helps pass configuration instructions at VM startup.

---

### 3️⃣ Install IIS and Chrome using Custom Script Extension
- Uploaded a **PowerShell script** to a Blob Container in Azure Storage
- Script tasks:
  - Install IIS Web Server
  - Install Google Chrome
  - Create or deploy an HTML file for IIS
- Attached the script to the VM using **Custom Script Extension**

---

### 4️⃣ Verify IIS Web Server
- Ensured IIS service is running
- Copied the **Public IP address** of the VM
- Accessed the server via browser:






**the custom Script **
# --- CONFIGURATION FLAGS ---
$InstallIIS    = $true
$InstallChrome = $true
$SiteContent   = "<h1>Welcome to My Azure VMSS Site</h1><p>Managed by Rishabhdev</p>"

# 1. Install IIS (if true)
if ($InstallIIS) {
    Write-Host "Installing IIS..."
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    
    # Set the Static Website HTML
    $SiteContent | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Force
}

# 2. Install Chrome (if true)
if ($InstallChrome) {
    Write-Host "Installing Google Chrome..."
    $LocalTempDir = $env:TEMP
    $ChromeInstaller = "$LocalTempDir\ChromeSetup.exe"
    
    # Download Chrome Installer
    (New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/chrome/install/375.126/chrome_installer.exe', $ChromeInstaller)
    
    # Run Silent Install
    Start-Process -FilePath $ChromeInstaller -Args "/silent /install" -Verb RunAs -Wait
}

Write-Host "Bootstrap process complete!"

