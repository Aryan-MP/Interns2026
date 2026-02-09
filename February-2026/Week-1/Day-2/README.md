# Day 2 – Azure Fundamentals & Virtual Machine

## Author
Manoj Gowda

## Day 2 Objective
- Understand Azure fundamentals (AZ-900 level)
- Learn Azure hierarchy
- Learn core Azure services
- Create a Virtual Machine
- Understand VM creation process
- Get first hands-on experience using Azure Portal

---

## 1. Azure Introduction
- Microsoft Azure is a cloud computing platform by Microsoft
- Provides services like:
  - Compute
  - Storage
  - Networking
  - Security
  - Database services

---

## 2. Azure Global Infrastructure

### Topics Covered
- Azure Regions
- Availability Zones
- Region Pairs

### Understanding Gained
- Importance of selecting the right region
- How Azure provides high availability
- How Azure handles disaster recovery using region pairs

---

## 3. Azure Hierarchy (Very Important)

### Order Explained
1. Tenant  
2. Management Group  
3. Subscription  
4. Resource Group  
5. Resource  

### Key Understanding
- Billing happens at the **Subscription** level
- All resources must exist inside a **Resource Group**
- Resource Group acts as a logical container

---

## 4. Azure Core Services Overview

### Services Explained
- Compute: Virtual Machines
- Networking: Virtual Network (VNet), Subnet
- Storage: Blob Storage, Managed Disks
- Database: Azure SQL and related services

### Purpose
To understand available Azure services before using them practically

---

## 5. Azure Security Basics

### Topics Covered
- Azure Active Directory (Azure AD)
- Role-Based Access Control (RBAC)

### Key Understanding
- Controls who can access what in Azure
- Common roles:
  - Owner
  - Contributor
  - Reader

---

## 6. Azure Pricing & Cost Basics

### Topics Covered
- Pay-as-you-go pricing model
- Capital Expenditure (CapEx) vs Operational Expenditure (OpEx)
- Cost awareness while creating resources

---

## 7. Virtual Machine Introduction
- A Virtual Machine is a cloud-based computer
- Consists of CPU, RAM, disk, and network
- Can run Windows or Linux operating systems

---

## 8. Virtual Machine Creation (Hands-On)

### VM Creation Tabs Explained
- Basics
- Disks
- Networking
- Management
- Advanced
- Tags
- Review + Create

### Key Configurations Understood
- VM name
- Region
- Operating System image
- VM size
- Authentication method
- Inbound ports
- Disk type
- Networking basics
- Network Security Group (NSG) usage

---

## 9. Networking Basics During VM Creation

### Topics Covered
- Virtual Network (VNet)
- Subnet
- Network Security Group (NSG)
- Inbound rules (RDP / SSH)

### Understanding
- NSG works like a firewall
- Required ports must be opened to access the VM

---

## 10. Virtual Machine Lifecycle Operations

### Operations Learned
- Start
- Stop (Deallocate)
- Restart
- Resize
- Delete

### Cost Understanding
- Stopped (deallocated) VM does not incur compute cost
- Disk storage cost continues even when VM is stopped

---

## 11. Day 2 Hands-On Work Done
- Created a Virtual Machine
- Selected OS image
- Configured VM size and region
- Configured networking and NSG
- Connected to the Virtual Machine

---

## 12. Day 2 Outcome
After completing Day 2, I was able to:
- Understand Azure platform fundamentals
- Clearly understand Azure hierarchy
- Create and manage a Virtual Machine
- Understand VM security and cost basics
- Navigate the Azure Portal confidently
