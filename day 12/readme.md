# [cite_start]Internship Report – Day 12 [cite: 1]

**Date:** February 17, 2026
**Intern Name:** Kiran Gowda
[cite_start]**Department:** Cloud & Networking [cite: 3]
[cite_start]**Topic Covered:** Networking Fundamentals, CIDR Calculation, Subnetting, and VNet Design [cite: 4]

## 🎯 Objective
[cite_start]On Day 12 of my internship, I learned fundamental networking concepts including IP addressing, CIDR notation, subnetting, host bit calculation, and decimal-to-binary conversion. [cite: 5, 111] [cite_start]These concepts are essential for designing secure and scalable cloud networks in platforms such as AWS and Microsoft Azure. [cite: 6, 112]

---

## 📚 1. Introduction to Networking
[cite_start]Networking enables communication between devices using unique identifiers known as IP addresses. [cite: 8, 114] Each IP address consists of:
* [cite_start]**Network Portion** - Identifies the network [cite: 9, 115]
* [cite_start]**Host Portion** - Identifies devices within the network [cite: 10, 116]

[cite_start]**Example:** `192.168.1.10/24` [cite: 12, 118]
* [cite_start]`/24` represents CIDR notation [cite: 13, 119]
* [cite_start]First 24 bits → Network [cite: 14, 120]
* [cite_start]Remaining 8 bits → Host [cite: 15, 121]

## 📊 2. IP Address Classes
[cite_start]IP addresses are categorized into different classes: [cite: 17, 123]

| Class | Range | Default Subnet Mask | Usage |
|---|---|---|---|
| **A** | [cite_start]0 - 126 [cite: 19, 124] | [cite_start]255.0.0.0 [cite: 19, 124] | [cite_start]Large networks [cite: 19, 124] |
| **B** | [cite_start]128 - 191 [cite: 19, 124] | [cite_start]255.255.0.0 [cite: 19, 124] | [cite_start]Medium networks [cite: 19, 124] |
| **C** | [cite_start]192 - 223 [cite: 19, 124] | [cite_start]255.255.255.0 [cite: 19, 124] | [cite_start]Small networks [cite: 19, 124] |
| **D** | [cite_start]224 - 239 [cite: 19, 124] | [cite_start]N/A [cite: 19, 124] | [cite_start]Multicast [cite: 19, 124] |
| **E** | [cite_start]240 - 255 [cite: 19, 124] | [cite_start]N/A [cite: 19, 124] | [cite_start]Experimental [cite: 19, 124] |

## 🧮 3. CIDR (Classless Inter-Domain Routing) & Formulas
[cite_start]CIDR notation defines how many bits belong to the network. [cite: 21, 126] 

[cite_start]**Formulas Learned:** [cite: 24, 129]
* [cite_start]**Host Bits** = 32 - CIDR [cite: 25, 130]
* [cite_start]**Total IP Addresses** = 2^n [cite: 26, 130]
* [cite_start]**Usable Hosts** = (2^n) - 2 [cite: 27, 130]
[cite_start]*(where n = number of host bits)* [cite: 28, 131]

## ✂️ 4. Subnetting
[cite_start]Subnetting divides a large network into smaller logical networks for better management and security. [cite: 34, 138]

## 🔢 5. Decimal to Binary Conversion
[cite_start]Each IP address contains four octets (8 bits each). [cite: 46, 150]

[cite_start]**Example: `192.168.1.1`** [cite: 48, 152]
* [cite_start]`192` = `11000000` [cite: 50, 154]
* [cite_start]`168` = `10101000` [cite: 50, 155]
* [cite_start]`1` = `00000001` [cite: 50, 155]
* [cite_start]`1` = `00000001` [cite: 50, 155]
* [cite_start]**Final Binary Representation:** `11000000.10101000.00000001.00000001` [cite: 52, 157]

---

## 🛠️ 6. Practical Task - Virtual Network (VNet) Design
[cite_start]As part of the practical exercise, we were assigned a task to design and plan a Virtual Network (VNet) with an optimal IP address range and create multiple subnets based on required host capacity. [cite: 54, 159]

### Deployed VNet Configuration
[cite_start]Based on the deployment in the Azure Portal, the VNet was segmented into the following structure to accommodate the required IPs for Cloud, Dev, and Test environments: [cite: 60, 61, 62]

| Subnet Name | CIDR | Available IPs | Address Range |
|---|---|---|---|
| **cloud** | `10.0.0.0/26` | 59 | 10.0.0.0 - 10.0.0.63 |
| **test** | `10.0.0.64/27` | 27 | 10.0.0.64 - 10.0.0.95 |
| **dev** | `10.0.0.128/26` | 59 | 10.0.0.128 - 10.0.0.191 |

### Azure Portal Deployment Verification
Below is the successful deployment of the calculated subnets within the Azure Virtual Network dashboard:

![Azure Subnets Deployment](Screenshot (195).png)

[cite_start]This planning ensured: [cite: 92, 189]
* [cite_start]Efficient IP utilization [cite: 93, 190]
* [cite_start]Proper network segmentation [cite: 94, 191]
* [cite_start]Future scalability [cite: 94, 192]

## 📝 Conclusion
[cite_start]Day 12 of the internship strengthened my understanding of networking fundamentals and practical subnet design. [cite: 103, 199] [cite_start]I learned how to calculate CIDR ranges, determine host requirements, and design a Virtual Network with multiple subnets based on real-world scenarios. [cite: 104, 200] [cite_start]These concepts are essential for cloud architecture, secure infrastructure deployment, and network segmentation in AWS and Azure environments. [cite: 105, 201]