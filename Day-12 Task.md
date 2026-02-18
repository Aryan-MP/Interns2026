#  Day-12 

## Topic: Networking Fundamentals & IPv4 Addressing with CIDR Calculations

---

# Introduction to Cloud Networking

Before deploying infrastructure in the cloud, it is essential to understand **core networking building blocks**.
Cloud providers (Azure, AWS, GCP) simulate traditional networking concepts using software-defined networking.

These concepts are the digital equivalents of physical devices used in on-premises data centers.

---

#  Key Networking Components

## 1️⃣ VPC / VNet (Virtual Private Cloud / Virtual Network)

A **VPC (AWS)** or **VNet (Azure)** is a logically isolated network inside the cloud.

It allows you to:

* Define your own IP address range
* Create subnets
* Control routing
* Secure communication between resources

 Think of it as your **private data center inside the cloud**.

---

## 2️⃣ Subnet

A **Subnet** is a smaller network carved out of a VPC/VNet.

Used to:

* Organize workloads
* Separate tiers (Web / App / DB)
* Apply different security rules

Example:

```
VNet: 10.0.0.0/16
 ├── Public Subnet: 10.0.1.0/24
 └── Private Subnet: 10.0.2.0/24
```

---

## 3️⃣ Router

A **Router** connects different networks and decides where traffic should go.

In cloud:

* Managed automatically by provider
* Handles communication between subnets, internet, VPN, etc.

Router = Traffic decision maker.

---

## 4️⃣ Switch

A **Switch** connects devices **within the same network**.

In cloud:

* Implemented virtually
* Allows VMs inside the same subnet to communicate

 Switch = Local communication enabler.

---

## 5️⃣ Hub (Hub-and-Spoke Model)

A **Hub Network** is a central network that connects multiple other networks (Spokes).

Used for:

* Centralized firewall
* Shared services
* Secure connectivity

Example:

```
         Spoke1
           |
Spoke2 — Hub — Spoke3
           |
         VPN / Internet
```

Hub = Central control network.

---

#  IPv4 Addressing Basics

IPv4 uses **32-bit addressing** written in dotted decimal format:

```
192.168.1.10
```

Each IP consists of:

```
Network Portion + Host Portion
```

Defined using **CIDR notation**.

---

#  Public vs Private IP Addresses

## Public IP Address

* Globally unique
* Accessible over the internet
* Assigned by ISP or Cloud Provider

Example:

```
52.174.23.10
```

Used for:

* Websites
* Public APIs
* Internet-facing services

---

## Private IP Address

Used only inside internal networks. Not routable on internet.

Defined by RFC1918 ranges:

| Range                         | CIDR           |
| ----------------------------- | -------------- |
| 10.0.0.0 – 10.255.255.255     | 10.0.0.0/8     |
| 172.16.0.0 – 172.31.255.255   | 172.16.0.0/12  |
| 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 |

Used for:

* Internal VMs
* Databases
* Application tiers

---

#  CIDR (Classless Inter-Domain Routing)

CIDR defines how many bits are used for the network.

Format:

```
IP Address / Prefix Length
Example: 10.0.0.0/24
```

---

## CIDR Determines:

* Number of subnets
* Number of hosts per subnet

---

#  CIDR Calculation Formula

## Total IP Addresses

```
Total IPs = 2^(32 - Prefix)
```

## Usable Hosts (Cloud Often Reserves Some)

```
Usable Hosts ≈ Total IPs - Reserved
```

---

#  Example 1: Calculate Hosts in /24

Given:

```
Network = 10.0.0.0/24
```

Calculation:

```
32 - 24 = 8 host bits
2^8 = 256 total IPs
```

Usable:

```
256 - 5 (Azure reserved) = 251 usable hosts
```

---

#  Example 2: Divide Network into 4 Subnets

Given:

```
Network = 10.0.0.0/24
Need = 4 Subnets
```

Step 1: Find subnet bits:

```
2^n = 4 → n = 2 bits
```

Step 2: Add bits to prefix:

```
24 + 2 = /26
```

Each subnet becomes `/26`.

---

## Subnet Breakdown

| Subnet  | CIDR          | IP Range    | Hosts     |
| ------- | ------------- | ----------- | --------- |
| Subnet1 | 10.0.0.0/26   | .0 – .63    | 59 usable |
| Subnet2 | 10.0.0.64/26  | .64 – .127  | 59 usable |
| Subnet3 | 10.0.0.128/26 | .128 – .191 | 59 usable |
| Subnet4 | 10.0.0.192/26 | .192 – .255 | 59 usable |

---

#  Example 3: Required 100 Hosts per Subnet

We find nearest power of 2:

```
2^7 = 128 (enough for 100 hosts)
```

So host bits = 7

Prefix:

```
32 - 7 = /25
```

Each subnet must be `/25`.

---

#  Why CIDR Planning Matters in Cloud

Proper subnetting ensures:

* No IP exhaustion
* Security segmentation
* Scalable architecture
* Efficient routing
* Cost-effective deployments

Poor planning leads to:
❌ Recreating VNets
❌ Migration downtime
❌ Broken connectivity

---