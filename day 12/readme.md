# Internship Report – Day 12

**Date:** February 17, 2026
**Intern Name:** Kiran Gowda
**Department:** Cloud & Networking
**Topic Covered:** Networking Fundamentals, CIDR Calculation, Subnetting, and VNet Design

## 🎯 Objective
On Day 12 of my internship, I learned fundamental networking concepts including IP addressing, CIDR notation, subnetting, host bit calculation, and decimal-to-binary conversion. These concepts are essential for designing secure and scalable cloud networks in platforms such as AWS and Microsoft Azure.

---

## 📚 1. Introduction to Networking
Networking enables communication between devices using unique identifiers known as IP addresses. Each IP address consists of:
* **Network Portion** - Identifies the network
* **Host Portion** - Identifies devices within the network

**Example:** `192.168.1.10/24`
* `/24` represents CIDR notation
* First 24 bits → Network
* Remaining 8 bits → Host

## 📊 2. IP Address Classes
IP addresses are categorized into different classes:

| Class | Range | Default Subnet Mask | Usage |
|---|---|---|---|
| **A** | 0 - 126 | 255.0.0.0 | Large networks |
| **B** | 128 - 191 | 255.255.0.0 | Medium networks |
| **C** | 192 - 223 | 255.255.255.0 | Small networks |
| **D** | 224 - 239 | N/A | Multicast |
| **E** | 240 - 255 | N/A | Experimental |

## 🧮 3. CIDR (Classless Inter-Domain Routing) & Formulas
CIDR notation defines how many bits belong to the network. 

**Formulas Learned:**
* **Host Bits** = 32 - CIDR
* **Total IP Addresses** = 2^n
* **Usable Hosts** = (2^n) - 2
*(where n = number of host bits)*

## ✂️ 4. Subnetting
Subnetting divides a large network into smaller logical networks for better management and security.

## 🔢 5. Decimal to Binary Conversion
Each IP address contains four octets (8 bits each).

**Example: `192.168.1.1`**
* `192` = `11000000`
* `168` = `10101000`
* `1` = `00000001`
* `1` = `00000001`
* **Final Binary Representation:** `11000000.10101000.00000001.00000001`

---

## 🛠️ 6. Practical Task - Virtual Network (VNet) Design
As part of the practical exercise, we were assigned a task to design and plan a Virtual Network (VNet) with an optimal IP address range and create multiple subnets based on required host capacity.

### Deployed VNet Configuration
Based on the deployment in the Azure Portal, the VNet was segmented into the following structure to accommodate the required IPs for Cloud, Dev, and Test environments:

| Subnet Name | CIDR | Available IPs | Address Range |
|---|---|---|---|
| **cloud** | `10.0.0.0/26` | 59 | 10.0.0.0 - 10.0.0.63 |
| **test** | `10.0.0.64/27` | 27 | 10.0.0.64 - 10.0.0.95 |
| **dev** | `10.0.0.128/26` | 59 | 10.0.0.128 - 10.0.0.191 |

### Azure Portal Deployment Verification
Below is the successful deployment of the calculated subnets within the Azure Virtual Network dashboard:

![Azure Subnets Deployment](Screenshot (195).png)

This planning ensured:
* Efficient IP utilization
* Proper network segmentation
* Future scalability

## 📝 Conclusion
Day 12 of the internship strengthened my understanding of networking fundamentals and practical subnet design. I learned how to calculate CIDR ranges, determine host requirements, and design a Virtual Network with multiple subnets based on real-world scenarios. These concepts are essential for cloud architecture, secure infrastructure deployment, and network segmentation in AWS and Azure environments.