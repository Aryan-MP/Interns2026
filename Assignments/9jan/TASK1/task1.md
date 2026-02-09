# Azure VM → Custom Image → VM Scale Set with Load Balancer

## 📘 Overview
This project demonstrates how to create an Azure Virtual Machine, install required software, convert it into a reusable image, and deploy a Virtual Machine Scale Set (VMSS) with autoscaling and load balancing.

The goal is to understand:
- Virtual Machines
- Custom Images
- VM Scale Sets (VMSS)
- Load Balancers
- Autoscaling using threshold values

---

## 🛠️ Technologies & Services Used
- Azure Virtual Machine
- Azure Custom Image (Specialized)
- Virtual Machine Scale Set (VMSS)
- Azure Load Balancer
- Autoscaling Rules
- Azure Networking (VNet, Subnet)

---

## 🧩 Task Implementation Steps

### 1️⃣ Create a Virtual Machine
- Created an Azure VM (Windows 11 pro)
- Installed required software:
  - Google Chrome
  - Visual Studio Code
- Verified software installation

---

### 2️⃣ Create a Custom Image
- Stopped the VM
- **specialised** the VM to remove machine-specific data
- Created a **Custom specialized Image** from the VM
- This image is reusable for scaling scenarios

> 💡 A generalized image is required for VM Scale Sets to ensure consistency across instances.

---

### 3️⃣ Create a Virtual Machine Scale Set (VMSS)
- Created a VM Scale Set using the custom image
- Configured:
  - **Minimum instances:** 2
  - **Maximum instances:** 20
- Ensured all instances launch with pre-installed software

---

### 4️⃣ Configure Load Balancer
- Attached an Azure Load Balancer to the VMSS
- Enabled traffic distribution across VM instances
- Ensured high availability and fault tolerance

---

### 5️⃣ Configure Autoscaling (Thresholds)
- Enabled autoscaling rules based on load
- Example thresholds:
  - Scale out when CPU usage exceeds defined value
  - Scale in when CPU usage drops below threshold
- VM instances automatically increase or decrease based on load

---

## 🎯 Key Learnings
- How to prepare a VM for image-based scaling
- Difference between **VM**, **Custom Image**, and **VMSS**
- How load balancers distribute traffic
- How autoscaling improves availability and cost efficiency
- Importance of threshold-based scaling rules

---

## ✅ Outcome
- Successfully deployed a scalable and load-balanced VM environment
- VM instances automatically scale based on system load
- All scaled VMs launch with pre-installed applications

---

## 📌 Conclusion
This project provides hands-on experience with Azure compute services and demonstrates how VM Scale Sets and Load Balancers enable scalable, highly available cloud architectures.
