# Day 8 – Assessment & Solution  
## Infrastructure as Code (ARM + CLI) & Container Deployment

---

## Assessment Objective
To deploy infrastructure using ARM templates and Azure CLI (without using Azure Portal), automate VM configuration, manage storage, and deploy a container using Azure Container Instance (ACI).

---

# Part 1 – ARM Template Deployment (Linux VM)

## What it is
Deploying complete infrastructure using ARM template and Azure CLI.

## Why it is done
- Avoid manual portal configuration
- Enable reusable infrastructure
- Automate cloud deployment
- Follow Infrastructure as Code (IaC) practice

## How it is done
- Created ARM template (JSON)
- Used parameters for vmName, location, vmSize, admin credentials
- Used secureString for password security
- Used dependsOn to control resource creation order
- Deployed using:

az deployment group create

Resources created:
- Virtual Network
- Subnet
- Network Security Group
- Public IP (Standard SKU)
- Network Interface
- Ubuntu Virtual Machine

### Screenshot – CLI Deployment (VS Code)
Shows successful ARM deployment execution.

<img width="1920" height="1080" alt="day8-cli-deployment" src="https://github.com/user-attachments/assets/a6721a20-a5bf-4bc7-9c86-f59f7d501885" />
![ARM CLI Deployment](./Screenshots/day8-cli-deployment.png)
![Uploading day8-cli-deployment.png…]()

---

## VM Verification in Azure

After CLI deployment, the VM was verified in Azure.

### Screenshot – VM in Azure Portal
Shows VM successfully created.

<img width="1920" height="1080" alt="day8-vm-overview" src="https://github.com/user-attachments/assets/ec16e8e0-c702-4fa3-8814-16150e4d29ca" />

![VM Overview](./Screenshots/day8-vm-overview.png)

---

# Part 2 – Windows VM Automation (Custom Script Extension)

## What it is
Automatic configuration of Windows VM without manual login.

## Why it is done
- Avoid manual RDP configuration
- Demonstrate DevOps-style provisioning
- Ensure consistent setup

## What was automated
- Installed IIS Web Server
- Installed Google Chrome
- Hosted custom HTML page in:
  C:\inetpub\wwwroot

### Screenshot – Custom HTML Page Hosted
Shows IIS running with custom content.

<img width="1920" height="1080" alt="day8-iis-custom-page" src="https://github.com/user-attachments/assets/ec22f684-4d6f-4d1b-86a3-c0894ee1c5c1" />

![IIS Hosted Page](./Screenshots/day8-iis-custom-page.png)

---

# Part 3 – Storage & Managed Disk

## What it is
Creating and attaching an additional managed disk to VM.

## Why it is done
- Separate OS and application data
- Understand disk lifecycle
- Practice disk attachment process

## How it is done
- Created Managed Data Disk (20 GB)
- Attached disk to Windows VM
- Logged into VM
- Formatted disk
- Verified disk usable

### Screenshot – Disk Created and Attached
Shows managed disk attached to VM.

<img width="1920" height="1080" alt="day8-disk-attached" src="https://github.com/user-attachments/assets/044bf95a-473d-43dc-85bd-d712bbf4adb2" />

![Managed Disk Attached](./Screenshots/day8-disk-attached.png)

### Key Concept
OS Disk:
- Mandatory
- Contains operating system

Data Disk:
- Optional
- Stores application data
- Independent lifecycle (not deleted automatically with VM)

---

# Part 4 – Azure Container Instance (ACI) Deployment

## What it is
Running a container directly in Azure without using a Virtual Machine.

## Why it is done
- Avoid managing VM and OS
- Simplify container deployment
- Reduce infrastructure overhead

## Issues Encountered
- InvalidOsType
- RegistryErrorResponse
- InaccessibleImage

## Final Working Solution
- Created Azure Container Registry (ACR)
- Imported nginx image into ACR
- Deployed Azure Container Instance using private ACR image
- Assigned public DNS
- Accessed container via browser

### Screenshot – Nginx Running in ACI
Shows nginx website successfully running from Azure Container Instance.
<img width="1920" height="1080" alt="day8-aci-nginx" src="https://github.com/user-attachments/assets/93504a5c-fbd0-44e6-8faf-585588050c4f" />


![ACI Nginx Output](./Screenshots/day8-aci-nginx.png)![Uploading day8-aci-nginx.png…]()


---

# Final Architecture Understanding

## VM-Based Architecture

Internet  
↓  
Public IP  
↓  
Virtual Machine  
↓  
Operating System  
↓  
Application  

Full infrastructure management required.

---

## Container-Based Architecture

Internet  
↓  
Azure Container Instance  
↓  
Application  

No VM management required.  
Azure manages infrastructure.

---

# Assessment Outcome

- Deployed full infrastructure using ARM + CLI
- Automated Windows VM configuration using Custom Script Extension
- Created and attached managed disk
- Understood OS vs Data Disk lifecycle
- Resolved real deployment errors
- Deployed container directly using Azure Container Instance
- Implemented Infrastructure as Code without using Azure Portal
