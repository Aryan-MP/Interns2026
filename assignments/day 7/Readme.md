Azure VM Configuration using Custom Script Extension (CSE)


This project demonstrates how to configure a Windows Virtual Machine in Microsoft Azure using Custom Script Extension (CSE).

The PowerShell script automates:

✅ Installation of IIS Web Server

✅ Installation of Google Chrome (Silent Installation)

✅ Creation of a Custom HTML Web Page

✅ Starting IIS Service

The script was executed through Azure VM Custom Script Extension.

Technologies Used

Microsoft Azure

Azure Virtual Machine (Windows Server)

Azure Custom Script Extension (CSE)

PowerShell

IIS (Web-Server Role)

MSI Silent Installation

Script Functionality
1️⃣ Install IIS Web Server

Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Installs:

IIS Web Server

IIS Management Tools

Required Dependencies

2️⃣ Create Custom HTML Web Page

The script dynamically creates an index.html file:

<html>
<body>
<h1>IIS Installed via CSE</h1>
<p>Chrome Installed via CSE</p>
<p>Hostname: $env:COMPUTERNAME</p>
</body>
</html>

Location:C:\inetpub\wwwroot\index.html

3️⃣ Install Google Chrome Silently

Downloads Chrome Enterprise MSI

Installs using msiexec in silent mode

No user interaction required
Start-Process msiexec.exe -ArgumentList '/i C:\Temp\chrome.msi /qn /norestart' -Wait

4️⃣ Start IIS Service

Start-Service W3SVC


Deployment Architecture
Azure Windows VM
        ↓
Custom Script Extension (CSE)
        ↓
PowerShell Script Execution
        ↓
IIS + Chrome Installation
        ↓
Custom Web Page Deployment


▶️ Deployment Method

The script was executed using Azure Custom Script Extension.

Example Azure CLI command:
az vm extension set \
  --resource-group <resource-group-name> \
  --vm-name <vm-name> \
  --name CustomScriptExtension \
  --publisher Microsoft.Compute \
  --settings '{"commandToExecute":"powershell -ExecutionPolicy Unrestricted -Command \"<script-content>\""}'


