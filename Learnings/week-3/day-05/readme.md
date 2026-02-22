 

## Topic: Deploy Windows VM and Execute Custom Script at Logon Using Custom Script Extension

---

#  Objective

In this lab, we will:

* Create a **Windows Virtual Machine** using ARM Template
* Configure a **Custom Script Extension (CSE)**
* Register the script to run as a **Logon Task** (Task Scheduler)
* Automatically execute the script whenever a user logs into the VM

This approach is used in enterprises to:

* Install software at first login
* Configure developer environments
* Apply post-deployment customization
* Enforce machine-level automation

---

#  Architecture Flow

```
ARM Deployment
     ↓
Windows VM Created
     ↓
Custom Script Extension Executes
     ↓
Registers Scheduled Task (At Logon)
     ↓
User Logs In → Script Runs Automatically
```

---

#  What is Custom Script Extension?

Azure **Custom Script Extension** allows you to:

* Download scripts into the VM
* Execute PowerShell automatically
* Perform post-deployment configuration

It runs **inside the VM** after provisioning is complete.

---

#  Why Use Logon Task Instead of Direct Execution?

Sometimes configuration must run:

✔ When a user logs in
✔ With user profile loaded
✔ After domain join
✔ When GUI-dependent setup is required

That’s where **Windows Task Scheduler (At Logon Trigger)** is used.

---

#  Files Required

```
day15-template.json
day15-parameters.json
script.ps1
```

---

#  Add ARM Template Below

Paste your ARM template in this section:

```json
   
   template.json file is present in the folder refer it for understanding of the arm template creation
```

---

#  Add Parameters File Below

```json
    
    parameters.json file in this folder,refer it for understanding


#  PowerShell Script Used by Custom Script Extension

Create a file named:

```
script.ps1
```

This script will:

* Create a Scheduled Task
* Configure it to run at user logon
* Execute your desired automation

Paste your script here:

```powershell
# 1. Set Security Protocol to TLS 1.2 for modern downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. Install Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 3. Install Google Chrome and VS Code using Chocolatey
# -y automatically accepts all prompts
Write-Host "Installing Chrome and VS Code..."
choco install googlechrome vscode -y

# 4. Create a small script to install VS Code extensions at Logon
# (Extensions MUST be installed in the user context, not the SYSTEM context)
$ExtensionScript = @"
    # Wait for VS Code to be fully registered in the path
    Start-Sleep -Seconds 15
    & 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-vscode.powershell --force
    & 'C:\Program Files\Microsoft VS Code\bin\code.cmd' --install-extension ms-python.python --force
"@

$ExtensionScriptPath = "C:\Users\Public\install_extensions.ps1"
Set-Content -Path $ExtensionScriptPath -Value $ExtensionScript

# 5. Set Windows to run the extension script ONE TIME when you log in
$RunOnceCommand = "powershell.exe -ExecutionPolicy Bypass -File $ExtensionScriptPath"
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "InstallVSExtensions" -Value $RunOnceCommand

Write-Host "Provisioning complete. Apps will be there when you RDP in!"
```

---

#  What Happens During Deployment?

## Step-1: ARM Creates Windows VM

Azure provisions:

* OS Disk
* Networking
* Admin Credentials

---

## Step-2: Custom Script Extension Runs

Extension:

* Downloads `script.ps1`
* Executes PowerShell silently
* Registers Windows Scheduled Task

---

## Step-3: Task Scheduler Entry Created

Task Configuration:

| Setting   | Value                    |
| --------- | ------------------------ |
| Trigger   | At Logon                 |
| Run Level | Highest Privilege        |
| User      | Any User / Specific User |
| Action    | Execute Script           |

---

## Step-4: User Logs into VM

When RDP login occurs:

```
Scheduled Task → Executes Script → Environment Configured
```

---

#  Deployment Command

```powershell
az login

az deployment group create `
--resource-group sivakumarderangula-rg `
--template-file template.json `
--parameters parameters.json
```

---

#  Validation Steps

After deployment:

1️ RDP into VM
2️ Open Task Scheduler:

```
taskschd.msc
```

3️ Verify task exists
4️ Log off → Log back in
5️ Confirm script executed

---

# How to Confirm Script Execution

Check:

| Location         | What to Look For    |
| ---------------- | ------------------- |
| Event Viewer     | Task Execution Logs |
| Custom Log File  | Output from script  |
| Installed Apps   | Expected changes    |
| Registry / Files | Created by script   |

---

#  Troubleshooting

| Issue              | Cause            | Fix                        |
| ------------------ | ---------------- | -------------------------- |
| Script not running | Execution Policy | Use Bypass                 |
| Task not created   | Extension failed | Check CSE logs             |
| Permission issue   | Not elevated     | Run with Highest Privilege |
| Script path wrong  | Download failed  | Validate URI               |

Check extension logs:

```
C:\WindowsAzure\Logs\Plugins\
```

---