# Day 15 – Deploy Windows VM and Execute Custom Script at Logon Using Custom Script Extension

**Date:** February 20, 2026  
**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of Day 15 was to implement post-deployment automation in Azure using:

- ARM Template deployment
- Windows Virtual Machine provisioning
- Azure Custom Script Extension (CSE)
- Windows Task Scheduler (Logon Trigger)

The lab focused on automatically executing scripts when a user logs into the VM.

This approach is widely used in enterprise environments to:

- Install developer tools at first login
- Configure machine environments
- Perform GUI-dependent setups
- Apply post-deployment automation
- Enforce standardized workstation configuration

---

# 2. Architecture Flow


ARM Deployment
↓
Windows VM Created
↓
Custom Script Extension Executes
↓
Registers Logon Task (RunOnce / Scheduled Task)
↓
User Logs In → Script Runs Automatically


This design separates:

- Infrastructure provisioning
- Post-deployment configuration
- User-context automation

---

# 3. What is Custom Script Extension?

Azure Custom Script Extension (CSE):

- Downloads scripts into the VM
- Executes PowerShell automatically
- Performs post-deployment configuration
- Runs after VM provisioning completes

It executes inside the VM as part of Azure VM extensions.

---

# 4. Why Use Logon Trigger Instead of Direct Execution?

Certain configurations must run:

- When user profile is loaded
- After domain join
- In GUI session
- In user security context (not SYSTEM)
- When installing per-user applications

Using Windows Task Scheduler (At Logon Trigger) ensures execution happens in the correct context.

---

# 5. Infrastructure Components

The ARM deployment creates:

- Virtual Network
- Subnet
- Network Security Group
- Public IP
- Network Interface
- Windows 11 VM
- Custom Script Extension

---

# 6. Custom Script Behavior

The script performs:

1. Sets TLS 1.2
2. Installs Chocolatey
3. Installs Google Chrome
4. Installs Visual Studio Code
5. Creates a secondary script for VS Code extensions
6. Registers RunOnce registry entry
7. Executes extension installation at user login

This separates SYSTEM-level installation from USER-level configuration.

---

# 7. Deployment Command

```powershell
az login

az deployment group create `
--resource-group <RESOURCE_GROUP_NAME> `
--template-file day15-template.json `
--parameters day15-parameters.json
8. What Happens During Deployment?
Step 1 – ARM Creates Windows VM

Azure provisions:

OS Disk

Networking

Admin Credentials

Public IP

NIC

Step 2 – Custom Script Extension Executes

Extension:

Downloads logon-script.ps1

Executes PowerShell silently

Registers RunOnce registry entry

Step 3 – Logon Trigger Registered

Registry Path:

HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce

This ensures execution when a user logs in.

Step 4 – User Logs In

When RDP login occurs:

User Login
     ↓
RunOnce Trigger
     ↓
Extension Script Executes
     ↓
Environment Configured
9. Validation Steps

After deployment:

RDP into VM

Open Task Scheduler:

taskschd.msc

Log off

Log back in

Confirm Chrome and VS Code are installed

Confirm VS Code extensions installed

10. How to Confirm Script Execution
Location	What to Check
Event Viewer	Task execution logs
Installed Apps	Chrome & VS Code present
VS Code Extensions	PowerShell + Python extensions
Registry	RunOnce entry removed after execution
CSE Logs	C:\WindowsAzure\Logs\Plugins
11. Troubleshooting Guide
Issue	Cause	Fix
Script not running	Execution Policy	Use Bypass
Task not created	Extension failed	Check CSE logs
Permission issue	Not elevated	Run with Highest Privilege
Script path incorrect	Download failure	Validate URI
Chocolatey not installing	TLS issue	Force TLS 1.2

Extension logs location:

C:\WindowsAzure\Logs\Plugins\
12. Architectural Insight

This pattern demonstrates:

Separation of infrastructure and configuration

Idempotent post-provision automation

Enterprise workstation provisioning model

User-context configuration best practice

Infrastructure as Code + OS-level automation

This architecture is commonly used in:

VDI environments

Developer VM provisioning

Enterprise workstation automation

Lab environments

13. Key Concepts Learned

Azure VM provisioning with ARM

Custom Script Extension workflow

Windows RunOnce registry automation

Logon-triggered execution

User-context vs SYSTEM-context execution

Chocolatey-based software provisioning

Enterprise-grade VM post-deployment design

14. Final Outcome

By the end of Day 15:

I deployed a Windows VM using ARM

I executed Custom Script Extension successfully

I implemented user-context automation at logon

I validated script execution

I understood enterprise VM provisioning workflows

15. Conclusion

Day 15 introduced advanced VM automation using Azure Custom Script Extension and Windows logon triggers.

This lab demonstrated how infrastructure provisioning can be extended into automated environment configuration.

This approach aligns with real-world enterprise automation standards and strengthens Infrastructure-as-Code proficiency.
