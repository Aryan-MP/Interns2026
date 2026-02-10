# Day 5 – Assessment: The Infrastructure Challenge

## Objective
To manually build and connect all required Azure components to deploy a functional Virtual Machine.  
The goal is to understand how individual resources work together while keeping the setup cost-efficient and low latency.

---

## Scenario
Instead of using the Quick Create option, the Virtual Machine was deployed by creating and connecting each required resource manually.  
This ensures better understanding of Azure networking, security, storage, and compute components.

---

# Exercise 1

## Task 1: Networking Setup

### What it is
Creating the network where the Virtual Machine will run.

### Why it is done
- Every VM needs a network to communicate
- Proper address space allows future scaling
- Network must exist before VM creation

### How it is done
- Created a Virtual Network (VNet)
- Defined an address space
- Created a Subnet inside the VNet

---

## Task 2: Security & Entry Points

### What it is
Setting up security rules and public access for remote management.

### Why it is done
- To control inbound and outbound traffic
- To allow remote access to the VM
- To keep the VM secure

### How it is done
- Created a Network Security Group (NSG)
- Added an inbound rule to allow management access (RDP or SSH)
- Created a Public IP Address for external connectivity

---

## Task 3: The Connection Layer (NIC)

### What it is
The Network Interface Card (NIC) connects the VM to the network.

### Why it is done
- VM cannot communicate without a NIC
- NIC acts as the connection point for network, security, and IP

### How it is done
- Created a Network Interface
- Attached the NIC to:
  - Virtual Network
  - Subnet
  - Network Security Group
  - Public IP Address

---

## Task 4: Storage Allocation

### What it is
Creating additional storage for the Virtual Machine.

### Why it is done
- OS disk is not enough for all use cases
- Data disk is used to store application or user data
- Disk must be in the same region to avoid latency

### How it is done
- Created a Managed Data Disk
- Ensured disk was created in the same region as the VM

---

## Task 5: Final Assembly (Compute)

### What it is
Creating the Virtual Machine using pre-created resources.

### Why it is done
- To understand how VM depends on existing resources
- To avoid automatic resource creation
- To ensure full control over infrastructure

### How it is done
- Created a Virtual Machine
- During VM creation:
  - Attached the existing Network Interface
  - Attached the existing Managed Data Disk
- No new network or storage was created automatically

---

## Task 6: Validation

### What it is
Verifying that the infrastructure was created correctly.

### Why it is done
- To confirm VM is working
- To ensure the data disk is attached and usable

### How it is done
- Logged into the Virtual Machine
- Verified that the extra data disk was visible inside the OS
- Confirmed the disk was ready for use

---

## Deliverables

The following deliverables were prepared:

- Screenshot of **Topology view** showing the relationship between:
  - VM
  - NIC
  - NSG
  - VNet
  - Subnet
  - Public IP
  - Data Disk
- Screenshots from **Deployments page** showing resource creation
- Documentation containing:
  - VM details
  - VNet and Subnet information
  - Public IP details
  - NSG rules
  - Disk information

---

## Assessment Outcome
- Successfully built a Virtual Machine using manual resource creation
- Understood how networking, security, storage, and compute are connected
- Gained confidence in troubleshooting VM deployment issues
- Learned infrastructure-level thinking instead of quick deployments
