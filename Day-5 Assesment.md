# Manual Azure Virtual Machine Deployment (End-to-End)

## Objective
Manually build and connect all required Azure resources to deploy a fully functional Virtual Machine without using Quick Create. Ensure compatibility, correct networking, and low-latency resource placement.

---

## Architecture Overview

Internet
   ↓
Public IP (PIP-VM)
   ↓
Network Security Group (NSG-VM)
   ↓
Network Interface (NIC-VM)
   ↓
Subnet (subnet-app)
   ↓
Virtual Network (day5vnet)
   ↓
Virtual Machine (standaloneVM)
   ↓
Managed Data Disk (Disk-data-vm)


---

## Resources Created

| Resource               | Name                      | Region        |
| ---------------------- | ------------------------- | ------------- |
| Resource Group         | Day5                      | Central India |
| Virtual Network        | day5vnet (10.0.0.0/16)    | Central India |
| Subnet                 | subnet-app (10.0.1.0/24)  | Central India |
| Network Security Group | NSG-VM                    | Central India |
| Public IP              | PIP-VM (Static, Standard) | Central India |
| Network Interface      | NIC-VM                    | Central India |
| Managed Disk           | Disk-data-vm (32GB)       | Central India |
| Virtual Machine        | standaloneVM              | Central India |


---

## Task 1 — Networking Setup

1. Created Virtual Network `day5vnet`
   - Address space: `10.0.0.0/16`
2. Created Subnet `subnet-app`
   - Address range: `10.0.1.0/24`

Purpose: Scalable private network with enough IP space.

---

## Task 2 — Security & Entry

Created Network Security Group `NSG-VM` with rules:

| Port | Protocol | Purpose                |
| ---- | -------- | ---------------------- |
| 22   | TCP      | SSH (Linux access)     |
| 3389 | TCP      | RDP (Windows optional) |

Created Static Public IP `PIP-VM`.

---

## Task 3 — Connection Layer

Created Network Interface `NIC-VM` and attached:

- VNet → day5vnet  
- Subnet → subnet-app  
- NSG → NSG-VM  
- Public IP → PIP-VM  

Purpose: Provide network path to VM.

---

## Task 4 — Storage Allocation

Created Managed Disk:

- Name: `Disk-data-vm`
- Size: 32 GB
- Type: Premium SSD
- Region: Central India (same as VM for zero latency)

---

## Task 5 — Final Assembly (Compute)

Created VM using existing resources only:

- Attached NIC → NIC-VM  
- Attached Data Disk → Disk-data-vm  
- No new network created  

---

## Task 6 — Validation

### SSH Service Fix
SSH service was initially inactive. Fixed using:

sudo systemctl enable ssh  
sudo systemctl start ssh  

### Verify Disk
lsblk

### Mount Disk (if needed)
sudo fdisk /dev/sdc  
sudo mkfs.ext4 /dev/sdc1  
sudo mkdir /data  
sudo mount /dev/sdc1 /data  

---

## Key Learnings

- Manual resource linking in Azure
- NSG and firewall troubleshooting
- VM connectivity debugging (SSH timeout)
- Disk attachment and initialization
- Azure networking architecture

---

## Cleanup (Cost Saving)

Stop VM → Deallocate  
OR  
Delete Resource Group → Day5
