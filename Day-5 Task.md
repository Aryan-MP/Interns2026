# Azure VM Networking Assessment – Step-by-Step Guide

This document explains **end-to-end steps** to create an Azure Virtual Machine **from scratch**, using **separately created networking resources**. It also explains **why Azure creates default resources** and how to **replace them with your own**.

---

## Architecture Overview

```
Virtual Network (VNet)
 └── Subnet
      └── Network Security Group (NSG)
           └── Network Interface (NIC)
                └── Public IP
                     └── Virtual Machine (VM)
```

---

## Task 1: Create Virtual Network (VNet) and Subnet

### Purpose
- VNet provides a private network for Azure resources.
- Subnet logically divides the VNet and hosts the VM.

### Steps
1. Go to **Virtual Networks** → **Create**
2. Select:
   - Resource Group
   - Region
3. VNet details:
   - Name: `vnet-lab`
   - Address space: `10.0.0.0/16`
4. Subnet configuration:
   - Subnet name: `subnet-vm`
   - Address range: `10.0.1.0/24`
5. Review and Create

<img src=".\Images\Day-5\Screenshot 2026-02-08 100059.png">

---

## Task 2: Create Network Security Group (NSG)

### Purpose
- NSG acts as a **firewall** to control inbound and outbound traffic.

### Steps
1. Go to **Network Security Groups** → **Create**
2. Enter:
   - Name: `nsg-vm`
   - Resource Group
   - Region
3. Create the NSG

### Add Inbound Rules (Example)
- Allow SSH (Linux):
  - Port: 22
  - Protocol: TCP
  - Action: Allow
  - Priority: 100

- Allow RDP (Windows):
  - Port: 3389
  - Protocol: TCP
  - Action: Allow

Outbound rules are allowed by default unless restricted.

<img src=".\Images\Day-5\Screenshot 2026-02-08 100038.png">

---

## Task 3: Create Network Interface (NIC)

### Purpose
- NIC connects the VM to the subnet, NSG, and Public IP.

### Steps
1. Go to **Network Interfaces** → **Create**
2. Enter:
   - Name: `nic-vm-custom`
   - Resource Group
   - Region
3. Networking:
   - Virtual Network: `vnet-lab`
   - Subnet: `subnet-vm`
   - Network Security Group: `nsg-vm`
4. Do NOT attach Public IP yet (optional)
5. Create NIC

<img src=".\Images\Day-5\Screenshot 2026-02-08 100541.png">

---

## Task 4: Create Public IP Address

### Purpose
- Public IP allows external access to the VM.

### Steps
1. Go to **Public IP addresses** → **Create**
2. Enter:
   - Name: `pip-vm-custom`
   - IP version: IPv4
   - Assignment: Static (recommended)
3. Create Public IP


<img src=".\Images\Day-5\Screenshot 2026-02-08 100734.png">
---

## Task 5: Configure Resource Associations

### 1. Associate NSG with Subnet
1. Open `nsg-vm`
2. Go to **Subnets** → **Associate**
3. Select:
   - VNet: `vnet-lab`
   - Subnet: `subnet-vm`

### 2. Attach Public IP to NIC
1. Open `nic-vm-custom`
2. Go to **IP configurations** → `ipconfig1`
3. Associate Public IP: `pip-vm-custom`
4. Save

### Result
- NIC is now connected to Subnet, NSG, and Public IP

---

## IMPORTANT NOTE (Before Creating the VM)

### Why Azure Creates a NIC and Public IP by Default

When creating a VM through the Azure Portal:
- Azure automatically creates a **NIC and Public IP** to ensure:
  - Safe defaults
  - Simpler user experience
  - Guaranteed connectivity

The portal does **not allow selecting an existing NIC** during VM creation to avoid:
- Configuration conflicts
- Zone or subnet mismatch
- Lifecycle ownership issues

Advanced tools like **Azure CLI, PowerShell, and Terraform** allow attaching existing NICs because they operate closer to the Azure Resource Manager (ARM) API.

---
## Task 6: Create Disk for VM
### Steps
- Search for the Disks in Azure portal.
- Create the Disk in the same region where all the other resources are created.

<img src=".\Images\Day-5\Screenshot 2026-02-08 101415.png">

---

## Task 7: Create Virtual Machine

### Steps
1. Go to **Virtual Machines** → **Create**
2. Enter:
   - VM name: `vm-lab`
   - Image: Ubuntu / Windows
   - Size: as required
3. Networking tab:
   - Allow Azure to create default NIC and Public IP
4. Review and Create VM

<img src=".\Images\Day-5\Screenshot 2026-02-08 102045.png">
---

## Task 8: Replace Default NIC with Custom NIC

### Purpose
- To ensure the VM uses **your pre-created networking resources**.

### Steps

#### 1. Stop the VM
- Open VM → **Stop** (Deallocate)

#### 2. Detach Default NIC
1. Go to VM → **Networking**
2. Identify auto-created NIC
3. Detach the NIC

#### 3. Attach Custom NIC
1. Still under VM Networking
2. Attach NIC: `nic-vm-custom`
3. Save

#### 4. Start the VM
- Start VM after NIC replacement

---
<img src="Images\Day-5\Screenshot 2026-02-08 103533.png">

---

<img src="Images\Day-5\Screenshot 2026-02-08 103946.png">

---

<img src="Images\Day-5\Screenshot 2026-02-08 103946.png">

---

