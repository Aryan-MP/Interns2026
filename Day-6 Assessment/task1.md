
# Azure Lab — VM to VM Scale Set with Autoscaling

## Objective
Build a complete Azure compute workflow starting from a single Virtual Machine, create both Specialized and Generalized images, deploy a Virtual Machine Scale Set (VMSS) from the generalized image, enable CPU-based autoscaling, and access instances securely using Azure Bastion.

---

## Architecture Overview

Virtual Machine
   ↓
Install Required Packages
   ↓
Create Specialized Image
   ↓
Create Generalized Image (Sysprep)
   ↓
Deploy VM Scale Set (2 Instances)
   ↓
Configure Autoscaling (CPU Based)
   ↓
Secure Access via Azure Bastion

---

## Step 1 — Create Virtual Machine

- Created a Windows Virtual Machine in Azure Portal  
- Selected appropriate size and region  
- Enabled RDP for remote access  
- Connected successfully to the VM  

Outcome: VM deployed and operational.

---

## Step 2 — Install Required Packages

- Logged into the VM using RDP  
- Installed required software packages  
- Verified installation using version/status commands  

Outcome: VM configured successfully.

---

## Step 3 — Create Specialized Image

- Stopped (Deallocated) the VM  
- Captured Specialized Image  

Concept:  
A specialized image is an exact copy of the VM including user accounts, machine identity, and installed software.

Outcome: Specialized image created successfully.

---

## Step 4 — Create Generalized Image (Sysprep)

- Ran Sysprep to remove system identity  
- Shutdown VM automatically  
- Captured Generalized Image  

Concept:  
A generalized image removes machine-specific identity and can be reused to create multiple VMs. Required for VM Scale Set.

Outcome: Generalized image created successfully.

---

## Step 5 — Deploy Virtual Machine Scale Set

- Created VM Scale Set using the generalized image  
- Instance count set to 2  
- Deployment completed successfully  

Concept:  
VMSS provides high availability, horizontal scaling, and identical VM instances.

Outcome: Two VM instances running successfully.

---

## Step 6 — Enable Autoscaling (CPU Based)

Configured autoscaling rules:

- Minimum instances: 1  
- Default instances: 2  
- Maximum instances: 4  

Scale Out Rule:
- CPU > 70% for 5 minutes → Increase instance count by 1  

Scale In Rule:
- CPU < 30% for 5 minutes → Decrease instance count by 1  

Testing: Generated CPU load inside VM to trigger scaling and verified instance increase.

Outcome: Autoscaling functioning correctly.

---

## Step 7 — Secure Access using Azure Bastion

- Configured Azure Bastion for VMSS  
- Connected to VM instances securely via browser  
- No public RDP exposure required  

Outcome: Secure remote access established.

---

## Final Result

Successfully implemented:

- Virtual Machine deployment  
- Package installation  
- Specialized Image creation  
- Generalized Image creation  
- VM Scale Set deployment  
- CPU-based Autoscaling  
- Secure Bastion connectivity  

---

## Key Learnings

- Difference between Specialized vs Generalized Image  
- Importance of Sysprep before creating reusable images  
- VM Scale Set architecture and scaling behavior  
- Autoscaling using performance metrics  
- Secure VM access using Azure Bastion  

---

## Conclusion

This lab demonstrated the complete lifecycle from a single VM to a scalable and highly available infrastructure using Azure VM Scale Sets with automated scaling and secure access.