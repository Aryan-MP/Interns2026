# Day 9 ‚Äì OS Switcher VM Deployment using ARM (Nested Templates)

## Author
Manoj Gowda

---

# Ì∑† Project Name

OS Switcher VM Deployment using ARM (with Nested Templates)

---

# ÌæØ Project Goal

The objective was to build an automated ARM-based deployment system where:

1. If osType = Windows ‚Üí Deploy Windows VM and install IIS automatically
2. If osType = Linux ‚Üí Deploy Linux VM and install Nginx automatically
3. Only ONE VM should exist at a time
4. Everything must be deployed using ARM template (Infrastructure as Code)
5. Implement Nested Template structure

---

# Ìøó Architecture Built

The system:

- Creates network infrastructure
- Creates a VM based on input parameter
- Installs correct web server automatically
- Ensures only one VM exists
- Uses nested templates for modular design

---

# Ì¥π Step 1 ‚Äì Infrastructure as Code (IaC)

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

# Ì¥π Step 2 ‚Äì Conditional OS Deployment Logic


Using ARM template logic:

- condition
- equals()

If osType = Windows ‚Üí Windows VM block runs  
If osType = Linux ‚Üí Linux VM block runs  

Only one VM resource block executes.

---

# Ì¥π Step 3 ‚Äì Automatic Web Server Installation

Creating VM alone was not enough.

Requirement:
- Windows ‚Üí IIS must install automatically
- Linux ‚Üí Nginx must install automatically

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

# Ì¥π Step 4 ‚Äì Enforcing Single VM (Complete Mode)

Deployment mode used:

--mode Complete

Complete mode behavior:

- If resource exists but not in template ‚Üí delete it
- When OS type changes ‚Üí old VM gets removed
- New VM gets created

Verified using:

az vm list

Result:
Only one VM exists at any time.

---

# Ì¥π Step 5 ‚Äì Nested Template Structure

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

# Ì¥π Errors Encountered & Lessons Learned

## 1Ô∏è‚É£ Storage Account Name Conflict
Storage account names must be globally unique.

---

## 2Ô∏è‚É£ VM Size Not Available
Not all VM sizes are available in all regions.

Solution:
Changed VM size.

---

## 3Ô∏è‚É£ Gen1 vs Gen2 Image Mismatch
Some VM sizes only support specific hypervisor generations.

Solution:
Matched image generation with VM size.

---

## 4Ô∏è‚É£ imageReference Cannot Be Changed
Azure does not allow changing OS of existing VM.

Solution:
Delete and recreate VM.

---

## 5Ô∏è‚É£ RBAC Authorization Failure
Insufficient permissions to delete or modify resources.

Solution:
Required Contributor or Owner role.

---

# Ì≥ö Topics Covered

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

# Ì∑† Final Deployment Logic

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

# ÌøÅ Final Outcome

Successfully implemented:

- OS-based VM deployment logic
- Automatic web server installation
- Single VM enforcement using Complete mode
- Nested template architecture
- Production-style ARM design

---

# Ì∑† What This Project Really Taught

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

If osType = Windows ‚Üí Windows VM block runs  
If osType = Linux ‚Üí Linux VM block runs  

Only one VM resource block executes.

---

# Ì¥π Step 3 ‚Äì Automatic Web Server Installation

Creating VM alone was not enough.

Requirement:
- Windows ‚Üí IIS must install automatically
- Linux ‚Üí Nginx must install automatically

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

# Ì¥π Step 4 ‚Äì Enforcing Single VM (Complete Mode)

Deployment mode used:

--mode Complete

Complete mode behavior:

- If resource exists but not in template ‚Üí delete it
- When OS type changes ‚Üí old VM gets removed
- New VM gets created

Verified using:

az vm list

Result:
Only one VM exists at any time.

---

# Ì¥π Step 5 ‚Äì Nested Template Structure

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

# Ì¥π Errors Encountered & Lessons Learned

## 1Ô∏è‚É£ Storage Account Name Conflict
Storage account names must be globally unique.

---

## 2Ô∏è‚É£ VM Size Not Available
Not all VM sizes are available in all regions.

Solution:
Changed VM size.

---

## 3Ô∏è‚É£ Gen1 vs Gen2 Image Mismatch
Some VM sizes only support specific hypervisor generations.

Solution:
Matched image generation with VM size.

---

## 4Ô∏è‚É£ imageReference Cannot Be Changed
Azure does not allow changing OS of existing VM.

Solution:
Delete and recreate VM.

---

## 5Ô∏è‚É£ RBAC Authorization Failure
Insufficient permissions to delete or modify resources.

Solution:
Required Contributor or Owner role.

---

# Ì≥ö Topics Covered

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

# Ì∑† Final Deployment Logic

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

# ÌøÅ Final Outcome

Successfully implemented:

- OS-based VM deployment logic
- Automatic web server installation
- Single VM enforcement using Complete mode
- Nested template architecture
- Production-style ARM design

---

# Ì∑† What This Project Really Taught

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

