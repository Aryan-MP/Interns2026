```markdown
# Week-2 / Day-12 / README.md

# Day 12 – Networking Fundamentals & IPv4 Addressing with CIDR Calculations

**Date:** February 17, 2026  
**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of Day 12 was to build a strong foundation in networking fundamentals required for cloud infrastructure deployment. The session focused on:

- Core networking components in cloud environments
- IPv4 addressing structure
- Public vs Private IP addressing
- CIDR notation and subnetting
- Host calculations and subnet design
- Importance of IP planning in Azure architecture

This session laid the groundwork for advanced networking implementations in later labs involving Load Balancers, VPNs, and DNS.

---

# 2. Introduction to Cloud Networking

Before deploying any infrastructure in the cloud, it is essential to understand networking fundamentals.

Cloud providers such as Microsoft Azure, AWS, and GCP implement **Software-Defined Networking (SDN)**. Instead of physical routers and switches, networking components are virtualized and controlled through software.

These cloud networking components simulate traditional on-premises data center devices.

Cloud networking provides:

- Logical isolation
- Controlled routing
- Secure communication
- Scalable architecture design

---

# 3. Key Networking Components

## 3.1 VPC / VNet (Virtual Private Cloud / Virtual Network)

A Virtual Network (Azure) or VPC (AWS) is a logically isolated network within the cloud.

It allows you to:

- Define your own IP address range
- Create subnets
- Configure routing
- Control inbound and outbound communication
- Secure internal workloads

A VNet functions as a private data center network hosted inside Azure.

### Architectural Role

The VNet is the foundation of all cloud networking. All virtual machines, load balancers, gateways, and application services are deployed inside a VNet.

---

## 3.2 Subnet

A subnet is a segmented portion of a VNet.

Subnets are used to:

- Organize workloads
- Separate tiers (Web, Application, Database)
- Apply specific security policies
- Control traffic using Network Security Groups

### Example Architecture

```

VNet: 10.0.0.0/16
├── Public Subnet: 10.0.1.0/24
└── Private Subnet: 10.0.2.0/24

```

Each subnet isolates a tier of the application while remaining within the same VNet.

---

## 3.3 Router

A router connects different networks and determines traffic flow.

In cloud environments:

- The router is managed automatically by the cloud provider.
- It enables communication between subnets.
- It connects VNets to the internet or VPN gateways.

The router acts as the traffic decision engine.

---

## 3.4 Switch

A switch connects devices within the same network.

In Azure:

- Switching is virtualized.
- VMs within the same subnet communicate through virtual switching.

Switches enable local communication within a subnet.

---

## 3.5 Hub-and-Spoke Model

The Hub-and-Spoke model is a network topology where:

- A central Hub network connects multiple Spoke networks.

### Purpose

- Centralized firewall management
- Shared services (DNS, monitoring, logging)
- Secure connectivity
- Simplified governance

### Example Topology

```

```
     Spoke1
       |
```

Spoke2 — Hub — Spoke3
|
VPN / Internet

```

The Hub acts as the central control network.

---

# 4. IPv4 Addressing Basics

IPv4 uses a 32-bit addressing scheme.

Format:

```

192.168.1.10

```

Each IPv4 address consists of:

- Network portion
- Host portion

The division between network and host is determined using CIDR notation.

---

# 5. Public vs Private IP Addresses

## 5.1 Public IP Address

A public IP address:

- Is globally unique
- Is accessible over the internet
- Is assigned by ISP or cloud provider

Example:

```

52.174.23.10

```

Used for:

- Websites
- Public APIs
- Internet-facing services

---

## 5.2 Private IP Address

Private IP addresses are used internally and are not routable on the internet.

Defined by RFC1918:

| Range | CIDR |
|-------|------|
| 10.0.0.0 – 10.255.255.255 | 10.0.0.0/8 |
| 172.16.0.0 – 172.31.255.255 | 172.16.0.0/12 |
| 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 |

Used for:

- Internal VMs
- Databases
- Application layers
- Backend services

---

# 6. CIDR (Classless Inter-Domain Routing)

CIDR notation defines how many bits are used for the network portion.

Format:

```

IP Address / Prefix Length

```

Example:

```

10.0.0.0/24

```

CIDR determines:

- Number of subnets
- Number of hosts per subnet
- Routing boundaries

---

# 7. CIDR Calculation Formula

## 7.1 Total IP Addresses

```

Total IPs = 2^(32 - Prefix)

```

## 7.2 Usable Hosts in Azure

Azure reserves 5 IP addresses per subnet.

```

Usable Hosts = Total IPs - 5

```

---

# 8. Practical CIDR Calculation Examples

---

## Example 1: Hosts in a /24 Network

Given:

```

10.0.0.0/24

```

### Step 1: Calculate Host Bits

```

32 - 24 = 8 host bits

```

### Step 2: Calculate Total IPs

```

2^8 = 256 total IPs

```

### Step 3: Usable IPs in Azure

```

256 - 5 = 251 usable hosts

```

---

## Example 2: Divide /24 into 4 Subnets

Given:

```

10.0.0.0/24
Need: 4 subnets

```

### Step 1: Determine Subnet Bits

```

2^n = 4
n = 2

```

### Step 2: New Prefix

```

24 + 2 = /26

```

Each subnet becomes /26.

### Subnet Breakdown

| Subnet | CIDR | IP Range | Usable Hosts |
|--------|------|----------|--------------|
| Subnet1 | 10.0.0.0/26 | .0 – .63 | 59 |
| Subnet2 | 10.0.0.64/26 | .64 – .127 | 59 |
| Subnet3 | 10.0.0.128/26 | .128 – .191 | 59 |
| Subnet4 | 10.0.0.192/26 | .192 – .255 | 59 |

(64 total IPs - 5 reserved = 59 usable)

---

## Example 3: Need 100 Hosts per Subnet

We find nearest power of 2:

```

2^7 = 128

```

Host bits required = 7

Prefix:

```

32 - 7 = /25

```

Each subnet must be `/25`.

---

# 9. Why CIDR Planning Matters in Cloud

Proper subnet design ensures:

- No IP exhaustion
- Secure network segmentation
- Scalable architecture
- Efficient routing
- Cost-effective deployments

Poor planning can result in:

- Recreating VNets
- Migration downtime
- Broken connectivity
- Service interruptions
- Architecture redesign

IP planning is critical because VNets cannot be easily resized after deployment without downtime.

---

# 10. Architectural Insight

Networking is the foundation of all cloud deployments.

Before deploying:

- Load Balancers
- Application Gateways
- VPN Gateways
- Kubernetes clusters
- Private endpoints

CIDR planning must be completed.

A well-designed VNet:

- Separates tiers properly
- Leaves room for future expansion
- Avoids overlapping IP ranges
- Supports hybrid connectivity

Day 12 emphasized that networking mistakes in cloud environments are expensive to fix later.

---

# 11. Key Concepts Learned

- Software-defined networking in cloud
- VNet and subnet architecture
- Public vs Private IP ranges
- IPv4 addressing structure
- CIDR notation
- Subnet calculation techniques
- Azure reserved IP behavior
- Hub-and-Spoke network model
- Importance of long-term IP planning

---

# 12. Final Outcome

By the end of Day 12:

- I developed a strong understanding of foundational networking concepts.
- I learned how to calculate CIDR ranges manually.
- I understood subnet segmentation strategies.
- I gained clarity on Azure IP reservation rules.
- I became capable of planning scalable VNet architectures.

This knowledge directly supports advanced implementations such as Load Balancers, VPN gateways, DNS resolution, and hybrid connectivity architectures.

---

# 13. Conclusion

Day 12 established the core networking knowledge required for cloud engineering.

Understanding IPv4 addressing and CIDR calculations is critical before deploying production infrastructure in Azure.

Accurate IP planning enables:

- High availability design
- Secure architecture
- Scalable deployments
- Long-term maintainability

This session formed the networking backbone for subsequent hands-on Azure labs.
```
