# Day 5 – Azure Virtual Machine (Linux)

## Author
Manoj Gowda

---

## Day 5 Objective
- Understand how a Virtual Machine is created in Azure
- Learn how Azure resources are connected to a VM
- Create a Linux (Ubuntu) Virtual Machine
- Connect to the VM using Git Bash (SSH)
- Perform basic Linux commands
- Gain confidence working inside a Linux VM

---

## 1. Virtual Machine Concept (Recap)
A Virtual Machine (VM) is a cloud-based computer.

It includes:
- CPU
- RAM
- Disk
- Network

The VM runs an Operating System. In this session, Linux (Ubuntu) was used.

### Key Understanding
- A VM is not a single Azure resource
- Multiple Azure resources work together to form a VM

---

## 2. Azure Hierarchy (VM Placement)
The Azure hierarchy was explained to understand where a VM is created.

Order:
- Tenant
- Subscription
- Resource Group
- Resources (VM, Disk, NIC, NSG, VNet)

### Understanding
- VM must be created inside a Resource Group
- Billing happens at the Subscription level

---

## 3. Components Involved in VM Creation
When a Linux VM is created, Azure creates or uses:

- Virtual Machine
- OS Disk
- Network Interface (NIC)
- Virtual Network (VNet)
- Subnet
- Network Security Group (NSG)
- Public IP Address

### Important Understanding
- VM does not connect directly to the network
- Network flow is:

VM → NIC → Subnet → VNet

---

## 4. Linux VM Creation (Hands-On)
The end-to-end VM creation process was demonstrated.

### Key Settings Used
- Image: Ubuntu (Linux)
- VM Size: Small size (example B1s)
- Authentication: SSH public key
- Username: example azureuser
- Inbound port: SSH (22)

### Understanding
- Linux VMs are accessed using SSH
- Port 22 must be open for SSH access

---

## 5. After VM Creation
After deployment, the following details were available:
- Public IP address
- Username
- SSH private key
- Ubuntu OS running

Resources created:
- Virtual Machine
- OS Disk
- NIC
- NSG
- VNet
- Subnet
- Public IP

---

## 6. Connecting to Linux VM Using Git Bash
Git Bash was used to connect to the Linux VM.

Steps:
- Opened Git Bash
- Navigated to SSH key location
- Connected using SSH command

Example command:
ssh -i <private-key-file> azureuser@<public-ip>

Successful login to the VM was achieved.

---

## 7. Basic Linux Commands Practiced
The following Linux commands were used:

- pwd – check current directory
- ls – list files
- touch – create file
- mkdir – create directory
- cd – move into directory
- echo – write content to file
- cat – read file content
- rm – delete file
- rm -r – delete directory

---

## 8. SSH Connection Flow
The SSH connection flow was explained as:
- SSH request sent from local system
- Request reaches VM public IP
- NSG checks port 22 rule
- NIC allows traffic
- VM receives request
- Linux SSH service allows login

### Important
- Both NSG and OS must allow SSH

---

## 9. VM Stop, Start and Cost Awareness
- Stop (Deallocate): VM stops and compute cost is not charged
- Start: VM runs again
- Disk cost continues even when VM is stopped

---

## 10. Common Issues Discussed
- SSH fails if port 22 is blocked
- Wrong username used
- SSH key file not found
- Public IP changes if dynamic

---

## 11. Day 5 Summary
- Created a Linux Ubuntu Virtual Machine
- Understood VM-related Azure components
- Connected to VM using SSH and Git Bash
- Performed basic Linux operations
- Learned VM security and networking basics

---

## 12. Day 5 Outcome
After Day 5, the following outcomes were achieved:
- Ability to create and manage a Linux VM
- Clear understanding of VM components
- Secure access to VM using SSH
- Confidence working in a Linux environment
- Basic troubleshooting knowledge for VM access
