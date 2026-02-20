# Internship Report – Day 14

**Date:** February 19, 2026  
**Intern Name:** Kiran Gowda  
**Role:** Cloud Engineer Trainee Intern  

## 🎯 Objective of the Session
Today’s session was divided into a comprehensive theoretical deep-dive and an advanced practical lab. The day began with an exploration of Microsoft Foundry documentation, image management, and Cloud Labs features. The afternoon focused heavily on core networking fundamentals, DNS architecture, and concluded with a practical implementation of High Availability using Azure Load Balancers and Infrastructure as Code (IaC).

---

## 📚 Morning Session: Foundry, Images & Cloud Labs

### 1. Microsoft Foundry Overview
Started the day with a detailed reading and overview of Microsoft Foundry documentation. Explored the project structure, key components, and how different sections are organized within the platform.

### 2. Images and Image Management
Explored the lifecycle and optimization of virtual machine images:
* **Definition:** Understanding what constitutes an image in cloud environments.
* **Best Practices:** The critical steps required before capturing an image, such as cleaning temporary files and emptying the recycle bin.
* **Optimization:** Why thorough system cleanup is vital for efficient, optimized image creation and rapid deployment.

### 3. Representations and Cloud Labs Overview
An overview session on the Cloud Labs tool, focusing on advanced platform features:
* **Multi-Agent Systems:** Discussed their use cases and why multi-agent architecture is implemented to handle complex, distributed tasks.
* **Embedded Shadow:** Explored this newly introduced feature, focusing on its core purpose and the specific architectural problems it solves.
* **Logon Scripts:** Understood what they are and why they are heavily utilized in automated system configuration and environment bootstrapping.

---

## 🌐 Afternoon Session: Networking Deep Dive

The afternoon transitioned into an in-depth session on networking fundamentals, specifically tailored for Microsoft Azure environments.

### Core Topics Covered:
* Basics of networking and routing.
* IP addresses and Subnet masks.
* Virtual Networks (VNets) and their functionality in isolating cloud resources.
* DHCP (Dynamic Host Configuration Protocol) mechanics.
* DNS (Domain Name System) architecture and securing Top-Level Domains (TLDs).

### Types of DNS Records Discussed:
* **A Record:** Maps a domain to an IPv4 address.
* **AAAA Record:** Maps a domain to an IPv6 address.
* **CNAME Record:** Forwards one domain or subdomain to another domain.
* **MX Record:** Directs email to a mail server.
* **TXT Record:** Allows administrators to insert text into DNS records (often used for verification).
* **NS Record:** Indicates which DNS server is authoritative for the domain.
* **PTR Record:** Used for reverse DNS lookups (IP to domain name).

---

## 🛠️ Practical Task 1: Virtual Machines and Load Balancer

To apply the networking concepts practically, the final task required hosting two distinct Linux web servers and configuring an Azure Public Load Balancer to distribute incoming traffic across them. 

### Phase 1: Manual Architecture Implementation
1. **Web Server Provisioning:** Created two Linux Virtual Machines (`LinuxVM1` and `LinuxVM2`) using the Ubuntu Server 24.04 LTS image. Ensured both VMs were deployed into the exact same Virtual Network to allow the Load Balancer to target them.
2. **Cloud-init Automation:** Injected a bash script via the "Custom Data" field to automatically install the Apache2 web server and write a custom HTML file (Blue text for VM1, Green text for VM2).
3. **Load Balancer Configuration:** Created a Public Standard Load Balancer, configured the Frontend IP, mapped the Backend Pool to the VMs, and set up an HTTP Health Probe on Port 80.

### Phase 2: Infrastructure as Code (IaC) Automation
After proving the concept manually, I automated the entire deployment using Azure Resource Manager (ARM) templates.
* **Syntax Shielding:** Encoded the Linux `cloud-init` bash scripts into Base64 (UTF-8) strings and embedded them dynamically into the ARM JSON payload.
* **Zero-Touch Provisioning:** Engineered a unified PowerShell script that bypassed regional capacity limits (utilizing Gen2 `Standard_B2as_v2` compute SKUs), handled resource group cleanup, generated the JSON dynamically, and achieved a one-click deployment.

### Verification and Testing (The "Ping-Pong" Effect)
By accessing the Load Balancer's Public IP address in a browser and initiating multiple requests, I successfully observed traffic distribution. The Load Balancer flawlessly alternated between the Blue site (VM 1) and the Green site (VM 2).


## 📝 Conclusion
Day 14 was incredibly dense, bridging the gap between platform administration (Foundry, Cloud Labs) and hardcore cloud engineering. I gained hands-on experience with Layer 4 network traffic distribution and learned how to troubleshoot VNet boundaries and Health Probes. Successfully translating a multi-component manual Load Balancer architecture into a single-click ARM template demonstrated the power of Infrastructure as Code for achieving rapid, consistent, and scalable cloud deployments.