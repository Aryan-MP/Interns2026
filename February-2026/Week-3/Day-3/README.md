# Day 14 – Foundry, Advanced Networking & High Availability using Azure Load Balancer (IaC)

**Date:** February 19, 2026
**Intern Name:** Manoj Gowda
**Role:** Cloud Engineer Trainee Intern

---

# 1. Session Objective

Day 14 combined platform-level exploration with advanced cloud engineering implementation.

The objectives of the session were:

* Understand Microsoft Foundry documentation and architecture.
* Learn VM image management best practices.
* Explore advanced Cloud Labs platform features.
* Deep dive into networking fundamentals in Azure.
* Understand DNS architecture and record types.
* Implement High Availability using Azure Public Load Balancer.
* Automate the entire architecture using Infrastructure as Code (ARM Templates).

This session bridged theory and real-world cloud deployment practices.

---

# 2. Morning Session – Microsoft Foundry, Images & Cloud Labs

## 2.1 Microsoft Foundry Overview

The session began with reviewing Microsoft Foundry documentation.

Focus areas included:

* Platform structure
* Project organization
* Component hierarchy
* Documentation navigation
* Architectural layout of modules

Understanding Foundry helped visualize how enterprise-scale cloud platforms structure their services and documentation.

---

## 2.2 Images and Image Management

A detailed discussion was conducted on virtual machine image lifecycle management.

### What is an Image?

In cloud environments, an image is a pre-configured template containing:

* Operating system
* System configuration
* Installed software
* Required dependencies

Images are used to deploy identical virtual machines quickly and consistently.

---

### Image Lifecycle Best Practices

Before capturing an image:

* Remove temporary files
* Clear system logs
* Empty recycle bin
* Remove unnecessary software
* Generalize the VM (if required)

Proper cleanup ensures:

* Smaller image size
* Faster deployment
* Reduced storage cost
* Optimized performance

---

### Importance of Optimization

Optimized images lead to:

* Rapid VM provisioning
* Efficient scaling
* Reduced storage overhead
* Consistent system behavior

This is critical in auto-scaling and enterprise deployments.

---

## 2.3 Cloud Labs Platform Features

An advanced overview of Cloud Labs architecture was conducted.

### Multi-Agent Systems

Multi-agent architecture distributes tasks across multiple independent components.

Benefits:

* Scalability
* Fault isolation
* Efficient workload handling
* Distributed processing

---

### Embedded Shadow

Explored this platform feature and its architectural purpose.

It is used to:

* Mirror environments
* Manage background processes
* Enhance distributed lab control
* Solve synchronization issues in dynamic lab environments

---

### Logon Scripts

Logon scripts are automated scripts executed during user login.

Purpose:

* System configuration
* Software installation
* Environment initialization
* Policy enforcement

These are widely used in automated environment provisioning.

---

# 3. Afternoon Session – Advanced Networking Deep Dive

The afternoon session focused on core networking concepts tailored for Azure environments.

---

## 3.1 Networking Fundamentals

Topics covered:

* Basics of routing
* IP addressing and subnet masks
* Network segmentation
* Traffic flow concepts
* Isolation strategies in cloud networks

---

## 3.2 Virtual Networks (VNet)

Azure Virtual Networks provide:

* Resource isolation
* Private communication
* Subnet segmentation
* Secure traffic routing

VNets are foundational for cloud architecture.

---

## 3.3 DHCP (Dynamic Host Configuration Protocol)

DHCP automatically assigns:

* IP addresses
* Subnet masks
* Default gateway
* DNS servers

Azure manages DHCP internally within VNets.

---

## 3.4 DNS Architecture

DNS translates domain names into IP addresses.

The session covered:

* DNS resolution process
* Authoritative name servers
* Top-Level Domains (TLDs)
* Domain hierarchy structure

---

## 3.5 DNS Record Types

### A Record

Maps domain name to IPv4 address.

### AAAA Record

Maps domain name to IPv6 address.

### CNAME Record

Maps one domain to another domain.

### MX Record

Specifies mail server for domain.

### TXT Record

Stores arbitrary text (often used for verification).

### NS Record

Specifies authoritative DNS server.

### PTR Record

Used for reverse DNS lookup (IP → Domain).

Understanding DNS is critical for:

* Application hosting
* Load balancing
* Email routing
* Domain verification

---

# 4. Practical Task 1 – High Availability using Azure Load Balancer

The practical objective was to implement High Availability by hosting two Linux web servers behind an Azure Public Load Balancer.

---

# 5. Phase 1 – Manual Architecture Implementation

## 5.1 Web Server Provisioning

Created two Linux VMs:

* LinuxVM1
* LinuxVM2

Image used:

Ubuntu Server 24.04 LTS

Important configuration:

* Both VMs deployed in the same VNet.
* Same subnet to allow Load Balancer backend association.
* NSG allowed HTTP (Port 80).

---

## 5.2 Cloud-init Automation

Used cloud-init via Custom Data field.

Script performed:

* Apache2 installation
* Creation of custom HTML page
* Unique color identification:

  * VM1 → Blue site
  * VM2 → Green site

This enabled easy traffic distribution verification.

---

## 5.3 Azure Public Load Balancer Configuration

Created:

* Public Standard Load Balancer

Configured:

* Frontend Public IP
* Backend Pool (LinuxVM1 & LinuxVM2)
* HTTP Health Probe on Port 80
* Load Balancing Rule for HTTP traffic

Health Probe ensured:

* Traffic only routed to healthy VMs.

---

# 6. Phase 2 – Infrastructure as Code (IaC) Automation

After manual validation, the entire deployment was automated using ARM templates.

---

## 6.1 Base64 Encoding (Syntax Shielding)

Linux cloud-init scripts were:

* Converted to UTF-8
* Encoded to Base64
* Embedded dynamically into ARM JSON

This ensured:

* Proper formatting
* Clean template execution
* No script parsing issues

---

## 6.2 Unified PowerShell Deployment Script

Created a single PowerShell script that:

* Handled resource group cleanup
* Generated ARM JSON dynamically
* Bypassed regional SKU limitations
* Used Gen2 Standard_B2as_v2 VM size
* Executed complete deployment in one click

This achieved zero-touch provisioning.

---

# 7. Verification – Load Balancer Testing

Accessed the Load Balancer Public IP in browser.

Repeated refresh actions resulted in:

* Alternating Blue page (VM1)
* Alternating Green page (VM2)

This confirmed:

* Successful traffic distribution
* Proper backend health monitoring
* Correct Load Balancer rule configuration

This behavior demonstrated real High Availability at Layer 4.

---

# 8. Key Technical Concepts Mastered

* VNet boundaries and subnet placement
* Load Balancer backend pools
* Health probe configuration
* Layer 4 traffic distribution
* Apache server automation
* ARM template dynamic scripting
* Base64 encoding for script injection
* Infrastructure as Code deployment workflow
* Zero-touch provisioning techniques

---

# 9. Architectural Insight

Day 14 demonstrated how:

* Multiple compute nodes increase availability.
* Load Balancers distribute traffic efficiently.
* Health probes ensure resilience.
* Infrastructure as Code enables repeatable architecture.
* Manual architecture can be transformed into automated deployment.

This reflects real-world production architecture patterns.

---

# 10. Final Outcome

By the end of Day 14, I successfully:

* Understood image management best practices.
* Explored advanced Cloud Labs architecture.
* Strengthened networking and DNS knowledge.
* Built a High Availability architecture manually.
* Converted the entire setup into an automated ARM deployment.
* Achieved traffic distribution verification.
* Demonstrated Infrastructure as Code capability for scalable cloud systems.

---

# 11. Conclusion

Day 14 was a comprehensive cloud engineering session combining:

Platform administration
Advanced networking
High availability design
Infrastructure automation

The successful translation of a manual load-balanced architecture into a single-click ARM deployment demonstrated:

* Strong understanding of Azure networking
* Mastery of cloud-init automation
* Proficiency in ARM template engineering
* Ability to implement scalable, resilient cloud systems


