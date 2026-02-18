# Day 9 – OS Switcher VM Deployment using ARM (Nested Templates)

## Author
Manoj Gowda

---

# Project Name

OS Switcher VM Deployment using ARM (with Nested Templates)

---

#     Project Goal

The objective was to build an automated ARM-based deployment system where:

1. If osType = Windows → Deploy Windows VM and install IIS automatically
2. If osType = Linux → Deploy Linux VM and install Nginx automatically
3. Only ONE VM should exist at a time
4. Everything must be deployed using ARM template (Infrastructure as Code)
5. Implement Nested Template structure

---

#     Architecture Built

The system:

- Creates network infrastructure
- Creates a VM based on input parameter
- Installs correct web server automatically
- Ensures only one VM exists
- Uses nested templates for modular design

---

#     Step 1 – Infrastructure as Code (IaC)

Instead of using Azure Portal, infrastructure was defined in JSON files.

Resources defined in ARM template:

- Virtual Network (VNet)
- Subnet
- Network Security Group (NSG)
- Public IP
- Network Interface (NIC)
- Virtual Machine

Azure reads the template and deploys resources automatically.

This approach is called:

Infrastructure as Code (IaC)

It acts as a blueprint for Azure.

---

#     Step 2 – Conditional OS Deployment Logic


Using ARM template logic:

- condition
- equals()

If osType = Windows → Windows VM block runs  
If osType = Linux → Linux VM block runs  

Only one VM resource block executes.

---

#     Step 3 – Automatic Web Server Installation

Creating VM alone was not enough.

Requirement:
- Windows → IIS must install automatically
- <img width="1920" height="1080" alt="Screenshot (145)" src="https://github.com/user-attachments/assets/620341b7-bf4d-4ce6-92e1-5b7c10cf2531" />

- Linux → Nginx must install automatically
<img width="1920" height="1080" alt="Screenshot (144)" src="https://github.com/user-attachments/assets/1063ad3e-a516-46b5-8924-1b7d463da51f" />

---

## Windows Implementation

Used Custom Script Extension.

Script executed inside VM:

Install-WindowsFeature -Name Web-Server

IIS installed without manual RDP login.

---

## Linux Implementation

Used Cloud-init.

At VM boot time, it executed:

- package_update: true
- packages:
  - nginx

Nginx installed automatically without SSH login.

---

#     Step 4 – Enforcing Single VM (Complete Mode)

Deployment mode used:

--mode Complete

Complete mode behavior:

- If resource exists but not in template → delete it
- When OS type changes → old VM gets removed
- New VM gets created

Verified using:

az vm list

Result:
Only one VM exists at any time.

---

#     Step 5 – Nested Template Structure

Initially everything was in one large template.

Later, it was modularized into:

- main.json (Parent template)
- network.json (Network resources)
- vm.json (VM resources)

Parent template calls child templates using:

Microsoft.Resources/deployments

Benefits:

- Modular structure
- Cleaner code
- Reusable components
- Enterprise-ready architecture

---
<img width="1920" height="1080" alt="Screenshot (148)" src="https://github.com/user-attachments/assets/84fa03c5-0215-40ca-9cf2-fc905612d13e" />

#     Errors Encountered & Lessons Learned

## 1️⃣ Storage Account Name Conflict
Storage account names must be globally unique.

---

## 2️⃣ VM Size Not Available
Not all VM sizes are available in all regions.

Solution:
Changed VM size.

---

## 3️⃣ Gen1 vs Gen2 Image Mismatch
Some VM sizes only support specific hypervisor generations.

Solution:
Matched image generation with VM size.

---

## 4️⃣ imageReference Cannot Be Changed
Azure does not allow changing OS of existing VM.

Solution:
Delete and recreate VM.

---

## 5️⃣ RBAC Authorization Failure
Insufficient permissions to delete or modify resources.

Solution:
Required Contributor or Owner role.

---

#     Topics Covered

- Azure Resource Manager (ARM)
- Infrastructure as Code (IaC)
- Parameters & Variables
- Conditional Deployment
- VM Extensions
- Cloud-init
- Deployment Modes (Incremental vs Complete)
- Nested Templates
- Azure CLI
- Resource Dependencies
- VM Image Compatibility
- RBAC (Role-Based Access Control)

---

#     Final Deployment Logic

When deployed with:

osType = Windows

Azure:
- Creates network
- Creates Windows VM
- Installs IIS
- Ensures only one VM exists

When deployed with:

osType = Linux

Azure:
- Deletes previous VM (Complete mode)
- Creates Linux VM
- Installs Nginx
- Ensures only one VM exists

Fully automated.

---

#     Final Outcome

Successfully implemented:

- OS-based VM deployment logic
- Automatic web server installation
- Single VM enforcement using Complete mode
- Nested template architecture
- Production-style ARM design

---

#     What This Project Really Taught

This project was not just about creating a VM.

It demonstrated:

- Infrastructure lifecycle management
- Why OS cannot be changed in-place
- Impact of deployment modes
- Importance of modular templates
- Automation without manual configuration
- Role-based permission control
- Enterprise-ready infrastructure design

Transition achieved:

From creating VMs  
To designing infrastructure architecture.
A parameter was added:

Using ARM template logic:

- condition
- equals()

If osType = Windows → Windows VM block runs  
If osType = Linux → Linux VM block runs  

Only one VM resource block executes.

---

#     Step 3 – Automatic Web Server Installation

Creating VM alone was not enough.

Requirement:
- Windows → IIS must install automatically
- Linux → Nginx must install automatically

---

## Windows Implementation

Used Custom Script Extension.

Script executed inside VM:

Install-WindowsFeature -Name Web-Server

IIS installed without manual RDP login.

---

## Linux Implementation

Used Cloud-init.

At VM boot time, it executed:

- package_update: true
- packages:
  - nginx

Nginx installed automatically without SSH login.

---

#     Step 4 – Enforcing Single VM (Complete Mode)

Deployment mode used:

--mode Complete

Complete mode behavior:

- If resource exists but not in template → delete it
- When OS type changes → old VM gets removed
- New VM gets created

Verified using:

az vm list

Result:
Only one VM exists at any time.

---

#     Step 5 – Nested Template Structure

Initially everything was in one large template.

Later, it was modularized into:

- main.json (Parent template)
- network.json (Network resources)
- vm.json (VM resources)

Parent template calls child templates using:

Microsoft.Resources/deployments

Benefits:

- Modular structure
- Cleaner code
- Reusable components
- Enterprise-ready architecture

---

#     Errors Encountered & Lessons Learned

## 1️⃣ Storage Account Name Conflict
Storage account names must be globally unique.

---

## 2️⃣ VM Size Not Available
Not all VM sizes are available in all regions.

Solution:
Changed VM size.

---

## 3️⃣ Gen1 vs Gen2 Image Mismatch
Some VM sizes only support specific hypervisor generations.

Solution:
Matched image generation with VM size.

---

## 4️⃣ imageReference Cannot Be Changed
Azure does not allow changing OS of existing VM.

Solution:
Delete and recreate VM.

---

## 5️⃣ RBAC Authorization Failure
Insufficient permissions to delete or modify resources.

Solution:
Required Contributor or Owner role.

---

#     Topics Covered

- Azure Resource Manager (ARM)
- Infrastructure as Code (IaC)
- Parameters & Variables
- Conditional Deployment
- VM Extensions
- Cloud-init
- Deployment Modes (Incremental vs Complete)
- Nested Templates
- Azure CLI
- Resource Dependencies
- VM Image Compatibility
- RBAC (Role-Based Access Control)

---

#     Final Deployment Logic

When deployed with:

osType = Windows

Azure:
- Creates network
- Creates Windows VM
- Installs IIS
- Ensures only one VM exists

When deployed with:

osType = Linux

Azure:
- Deletes previous VM (Complete mode)
- Creates Linux VM
- Installs Nginx
- Ensures only one VM exists

Fully automated.

---

#     Final Outcome

Successfully implemented:

- OS-based VM deployment logic
- Automatic web server installation
- Single VM enforcement using Complete mode
- Nested template architecture
- Production-style ARM design

---

#     What This Project Really Taught

This project was not just about creating a VM.

It demonstrated:

- Infrastructure lifecycle management
- Why OS cannot be changed in-place
- Impact of deployment modes
- Importance of modular templates
- Automation without manual configuration
- Role-based permission control
- Enterprise-ready infrastructure design

Transition achieved:

From creating VMs  
To designing infrastructure architecture.

