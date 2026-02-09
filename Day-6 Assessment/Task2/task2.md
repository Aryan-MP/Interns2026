# Task 2 — Install IIS & Chrome using Custom Data and Custom Script Extension

## Step 1 — Create Windows VM with Custom Data

A Windows Virtual Machine was created in Azure, and Custom Data was provided during VM provisioning.

Custom Data executes only once during the initial VM setup and is used to pass configuration parameters.

Parameters used:

$InstallIIS    = $true  
$InstallChrome = $true  
$IISData       = "this is me"

---

## Step 2 — Upload Script to Storage Account

A PowerShell script was prepared to automate:

- IIS installation  
- Chrome installation  
- IIS homepage update with custom message  

Steps performed:

- Created Azure Storage Account  
- Created Blob Container  
- Uploaded PowerShell script (install.ps1)  
- Generated Script URL / SAS URL  

---

## Step 3 — Execute Script using Custom Script Extension

Custom Script Extension (CSE) was attached to the VM to download and execute the PowerShell script from Storage.

The script performed:

- IIS installation and service start  
- Default IIS page update with custom message  
- Silent installation of Google Chrome  

Script execution logs are stored at:

C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\

---

## Step 4 — Verify IIS Installation

After successful script execution:

- IIS service running ✔  
- Custom message written to IIS homepage ✔  
- Chrome installed ✔  

Accessed IIS page using browser:

http://<Public-IP>

Expected output:

this is me

---

## Key Observations

- Custom Script Extension enables automated software installation  
- Custom Data executes only once during VM provisioning  
- Scripts can automate full VM configuration  
- Azure Storage helps host automation scripts  
- Automation reduces manual configuration effort  

---

## Result

- IIS installed automatically on Windows VM ✔  
- Chrome installed automatically ✔  
- IIS served the configured custom message ✔  
- Custom Script Extension executed successfully ✔  
- Automated VM configuration verified ✔  

---
