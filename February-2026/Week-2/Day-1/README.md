# Day 6 – OS Images, Generalized vs Specialized, Automation

## Author
Manoj Gowda

---

## Day 6 Objective
- Understand OS images in Azure
- Learn different types of OS images
- Understand Generalized vs Specialized VMs
- Learn Managed OS images
- Create multiple VMs from images
- Understand auto-scale concept using images
- Automate software installation
- Deploy IIS using Custom Script Extension

---

## 1. What is an OS Image
An OS image is a **template** used to create Virtual Machines.

It contains:
- Operating System
- Installed software
- Configuration settings

### Purpose
- Avoid repeating OS and software installation
- Create identical VMs quickly
- Save time during VM creation

---

## 2. Types of OS Images

### Marketplace Image
- Provided by Azure
- Clean operating system
- No extra software installed

Examples:
- Ubuntu
- Windows Server

Used when:
- A fresh VM is required

---

### Custom Image
- Created by the user
- Includes OS and installed software
- Faster VM creation

Used when:
- Same setup is needed multiple times

---

## 3. Managed OS Image
Managed images are handled completely by Azure.

### Key Points
- No storage account management needed
- More reliable and scalable
- Recommended approach for production

### Understanding
- Managed images simplify image management
- Used for automation and scaling

---

## 4. Generalized vs Specialized VM (Important Concept)

### Generalized VM
- Machine-specific data removed
- No user accounts retained
- No computer name retained

For Windows:
- Uses Sysprep

For Linux:
- Uses waagent deprovision

Used for:
- Auto scaling
- VM Scale Sets
- Large deployments

---

### Specialized VM
- Machine-specific data retained
- Users and settings remain
- Exact copy of original VM

Used for:
- Cloning
- Backup-like scenarios

---

### Quick Comparison
- Generalized: clean template, new user and hostname, used for scaling
- Specialized: exact copy, same user and hostname, used for cloning

---

## 5. Task 1 – Create Base VM
A base VM was created (Windows or Linux).

### Software Installed
- Google Chrome
- Python

### Purpose
- Use this VM to create images
- Avoid reinstalling software repeatedly

---

## 6. Create Specialized Image
Steps followed:
- Stopped the VM
- Clicked Capture
- Selected image type as Specialized
- Created the image

### Result
- Image included OS, Chrome, Python, users, and configurations

### VM Creation from Specialized Image
- New VM created from specialized image
- VM had same setup as original

---

## 7. Create Generalized Image

### For Windows VM
- Logged into VM
- Ran Sysprep
- Selected Generalize and Shutdown

### For Linux VM
Commands used:
- sudo waagent -deprovision+user
- sudo shutdown -h now

### Capture Generalized Image
- Captured VM as a Generalized image

### VM Creation from Generalized Image
- New VM created from generalized image
- New username and hostname created
- Chrome and Python were already installed

---

## 8. Auto-Scale Concept (Image Based)
Understanding gained:
- Multiple identical VMs can be created using one image
- Generalized images are required for scaling
- Used in VM Scale Sets and auto-scaling scenarios

---

## 9. Task 2 – Custom Script Extension (Automation)

### What is Custom Script Extension
- Runs scripts automatically on a VM
- No manual login required

Used for:
- Software installation
- Configuration
- Automation tasks

---

## 10. Deploy IIS Using Custom Script Extension
Objective:
- Automatically install IIS
- Install Chrome
- Create IIS data folder

Script used:
- PowerShell script to install IIS and Chrome
- Created IIS data folder

---

## 11. Apply Custom Script Extension
Steps followed:
- Opened VM
- Went to Extensions + Applications
- Added Custom Script Extension
- Pasted script
- Ran the extension

---

## 12. Verify IIS Installation
- Opened browser
- Entered VM Public IP
- IIS default page loaded successfully

### Understanding
- IIS installed without logging into VM manually

---

## 13. Why This is Important
- Automation reduces manual work
- Same setup can be reused
- Used in real production environments
- Works with images and scaling

---

## 14. Common Mistakes Discussed
- Forgetting to generalize VM
- Using specialized image for scaling
- Losing admin or SSH credentials
- Not opening port 80 for IIS
- Running Sysprep incorrectly

---

## 15. Day 6 Hands-On Summary
- Learned OS image concepts
- Created generalized and specialized images
- Created multiple VMs from images
- Installed software using images
- Used Custom Script Extension for automation
- Deployed IIS without manual login

---

## 16. Day 6 Outcome
After Day 6, the following outcomes were achieved:
- Understood image-based VM deployment
- Knew when to use generalized or specialized images
- Created scalable VM setups
- Automated software installation
- Deployed web servers using extensions
