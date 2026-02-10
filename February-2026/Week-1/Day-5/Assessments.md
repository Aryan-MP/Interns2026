# Day 5 – Assessment & Solution  
## Azure Virtual Machine (Linux)

---

## Objective
To create a Linux Virtual Machine in Azure, understand its components, connect using SSH, and perform basic Linux operations.

---

## Task 1: Linux Virtual Machine Creation

### What it is
Creating a Linux Virtual Machine in Azure using the Azure Portal.

### Why it is done
- To run applications on Linux in the cloud
- To understand how Azure resources work together
- To gain hands-on experience with VM creation

### How it is done
- Opened Azure Portal
- Selected subscription and resource group
- Chose Ubuntu Linux image
- Selected a small VM size
- Configured SSH authentication
- Allowed SSH (port 22)
- Reviewed and created the VM

---

## Task 2: Understanding VM Components

### What it is
Understanding the Azure resources created along with the VM.

### Why it is done
- VM depends on multiple Azure resources
- Helps in troubleshooting and cost management

### How it is done
- Observed resources created during VM deployment:
  - OS Disk
  - NIC
  - NSG
  - VNet
  - Subnet
  - Public IP
- Understood network flow from VM to VNet

---

## Task 3: Connecting to Linux VM using SSH

### What it is
Connecting to the Linux VM remotely using SSH.

### Why it is done
- Linux VMs are managed through terminal access
- SSH provides secure remote access

### How it is done
- Opened Git Bash
- Navigated to SSH key location
- Used SSH command with private key and public IP
- Successfully logged into the VM

---

## Task 4: Performing Basic Linux Operations

### What it is
Executing basic Linux commands inside the VM.

### Why it is done
- To become comfortable working in Linux
- To manage files and directories inside the VM

### How it is done
- Checked directory and files
- Created and deleted files
- Created and removed directories
- Read and wrote file content using commands

---

## Task 5: VM Stop, Start and Cost Awareness

### What it is
Managing VM state and understanding cost behavior.

### Why it is done
- To avoid unnecessary cost
- To understand billing basics

### How it is done
- Stopped (deallocated) the VM
- Observed that compute cost stopped
- Understood that disk cost continues
- Started the VM again when required

---

## Assessment Outcome
- Linux VM created successfully
- VM components clearly understood
- Secure SSH connection established
- Basic Linux commands executed
- Cost and VM lifecycle concepts understood
