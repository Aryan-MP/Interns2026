# Day 5 - Assignment

## Topic : Virtual Machine Deployment

## Manual end-to-end deployment of a Virtual Machine

### 1. Networking Setup
Created a Virtual Network (VNet)
Defined a Subnet within the VNet
Planned sufficient address space for future scalability
Ensured region alignment across all resources
Concepts Applied
IP addressing strategy
Network segmentation
Resource regional consistency

### 2. Security & Entry Configuration
Created a Network Security Group (NSG)
Configured inbound rule for remote access (RDP/SSH)
Created a Public IP Address for external connectivity
Concepts Applied
Controlled inbound traffic
Secure remote management
Exposure minimization through NSG rules

### 3. Network Interface Configuration
Created a Network Interface (NIC)
Manually associated:
VNet
Subnet
NSG
Public IP
Concepts Applied
Explicit resource association
Layered network architecture
Dependency mapping

### 4. Storage Allocation
Created a Managed Data Disk
Ensured disk location aligned with VM region
Prepared disk for zero-latency attachment
Concepts Applied
Managed disk architecture
Performance and latency considerations
Region-based storage placement

### 5. Virtual Machine Deployment (Final Assembly)
Deployed Virtual Machine
Attached pre-created:
Network Interface
Managed Data Disk
Avoided auto-created networking and storage resources
Concepts Applied
Compute and infrastructure integration
Manual dependency control
Optimized resource deployment

### 6. Validation
Logged into the VM
Verified additional data disk visibility
Confirmed disk readiness for formatting and usage
Reviewed Azure Portal Topology view to validate resource relationships
