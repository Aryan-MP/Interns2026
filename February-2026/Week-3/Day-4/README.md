```markdown
# Week-2 / Day-14 / README.md

# Day 14 – Advanced Networking, DNS Resolution Flow, VPN Concepts & Azure Load Balancer Implementation

**Date:** February 19, 2026  
**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of Day 14 was to extend foundational networking knowledge from Day 12 into advanced networking concepts, including:

- DNS resolution flow
- Recursive and iterative DNS queries
- VPN architecture and secure connectivity
- Azure traffic distribution services
- Implementation of Azure Load Balancer using ARM Templates

This session combined deep theoretical networking concepts with practical Infrastructure as Code (IaC) implementation.

---

# 2. Deep Dive into Networking (Continuation from Day 12)

In earlier labs, the focus was on:

- Virtual Networks (VNet)
- Subnet segmentation
- CIDR planning
- Public vs Private IP addressing

Day 14 expanded on how communication actually happens:

- Across the public internet
- Inside Azure virtual networks
- Between hybrid environments

Understanding packet flow and name resolution is critical before implementing load balancing and secure connectivity.

---

# 3. Domain Name System (DNS)

## 3.1 What is DNS?

DNS (Domain Name System) translates human-readable domain names into IP addresses.

Example:

```

[www.google.com](http://www.google.com) → 142.250.x.x

```

Without DNS, users would need to remember numeric IP addresses for every website.

DNS operates as a distributed hierarchical database.

---

# 4. DNS Hierarchy Structure

DNS is structured as a tree:

```

```
            (Root) .
             |
    ---------------------
    |         |        |
   .com      .org     .net
    |
  google.com
    |
 www.google.com
```

```

Each level in the hierarchy is responsible for answering a specific part of the query.

---

# 5. DNS Resolution Process (Step-by-Step)

When a user types:

```

[www.google.com](http://www.google.com)

```

The following process occurs:

---

## Step 1 – Local Cache Check

The system checks:

- Browser cache
- Operating system cache
- Hosts file

If not found, the request is forwarded to a DNS Resolver (ISP DNS or Azure DNS).

---

## Step 2 – Query Root Server

The resolver asks:

"Where is .com?"

Root server responds:

"I do not know google.com, but ask the .com TLD server."

---

## Step 3 – Query TLD Server

Resolver asks:

"Where is google.com?"

TLD server responds:

"Ask Google's authoritative name server."

---

## Step 4 – Query Authoritative Name Server

Resolver asks:

"What is the IP for www.google.com?"

Authoritative server returns the IP address.

---

## Step 5 – IP Returned to Client

The resolver sends the IP back to the client.

The browser then connects directly to the IP address.

---

# 6. Iterative vs Recursive Queries

## Recursive Query

The client requests the resolver:

"Give me the final answer."

The resolver performs all lookup steps internally.

Used by:

- Browsers
- Applications
- Client systems

---

## Iterative Query

A DNS server responds with the best available information.

Example:

"I do not know the final answer, but ask this server."

Used between DNS servers internally.

---

# 7. Common DNS Record Types

| Record | Purpose |
|---------|----------|
| A | Maps domain to IPv4 |
| AAAA | Maps domain to IPv6 |
| CNAME | Alias to another domain |
| MX | Mail routing |
| TXT | Verification / security metadata |
| NS | Name server delegation |

DNS records control how applications, email, and web services are resolved globally.

---

# 8. Virtual Private Network (VPN)

## 8.1 What is a VPN?

A VPN (Virtual Private Network) creates a secure encrypted tunnel between networks.

Used to:

- Connect on-premises infrastructure to Azure
- Access private resources securely
- Encrypt traffic over public internet

---

## 8.2 How VPN Works

```

User → Encrypted Tunnel → Azure VPN Gateway → Private Resources

```

Traffic characteristics:

- Encrypted
- Authenticated
- Securely routed

---

## 8.3 Types of VPN

### Site-to-Site VPN

- Connects on-premises network to Azure VNet
- Used for enterprise hybrid architecture

### Point-to-Site VPN

- Connects individual users to Azure VNet
- Used for remote access scenarios

---

# 9. Azure Traffic Distribution Services

Azure provides multiple services to distribute and manage traffic.

---

# 9.1 Azure Load Balancer

- Layer 4 (TCP/UDP)
- Regional service
- IP-based routing
- High throughput and low latency
- No DNS-based routing

Used for:

- VM-based applications
- Internal scaling
- High Availability inside a region

---

# 9.2 Azure Traffic Manager

- DNS-based routing
- Global load balancing
- Routes users to nearest healthy region

Used for:

- Multi-region applications
- Disaster recovery
- Geographic routing

---

# 10. Difference: Load Balancer vs Traffic Manager

| Feature | Load Balancer | Traffic Manager |
|----------|---------------|-----------------|
| Layer | L4 (Transport) | DNS |
| Scope | Regional | Global |
| Routing Type | IP-based | DNS-based |
| Primary Use | VM scaling | Geo-routing |

---

# 11. Practical Task – Azure Load Balancer Implementation using ARM Template

## Deployment Objective

Deploy:

- Virtual Network
- Subnet
- Network Security Group
- Two Backend Virtual Machines
- Public Standard Load Balancer
- Health Probe
- Backend Pool
- Load Balancing Rule
- VM Extension to install NGINX

---

# 12. Files Used

```

day14-lb-template.json
day14-lb-parameters.json

````

---

# 13. Deployment Command

```bash
az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file day14-lb-template.json \
  --parameters day14-lb-parameters.json
````

---

# 14. Validation Steps

After successful deployment:

1. Retrieve Load Balancer Public IP
2. Open browser:

```
http://<LoadBalancer-IP>
```

3. Refresh multiple times.

Expected behavior:

Traffic alternates between VM1 and VM2.

---

# 15. What Happens Internally

```
Client Request
     ↓
Azure Load Balancer
     ↓
Health Probe Checks VM Status
     ↓
Distributes Request to Healthy VM
```

### Health Probe Logic

* Checks port 80 every 15 seconds
* If probe fails twice, VM removed from rotation
* Only healthy instances receive traffic

This ensures High Availability at Layer 4.

---

# 16. Architectural Insight

This implementation demonstrates:

* Layer 4 traffic distribution
* Stateless web server scaling
* Backend pool architecture
* Health-based failover
* Infrastructure as Code repeatability

The architecture can be extended with:

* VM Scale Sets
* Application Gateway (Layer 7)
* Azure Front Door (Global entry point)
* Availability Zones

---

# 17. Key Concepts Learned

* DNS hierarchical resolution
* Recursive vs Iterative queries
* DNS record management
* VPN secure connectivity models
* Azure Load Balancer architecture
* Backend pool configuration
* Health probe mechanics
* ARM template copy loops
* Infrastructure as Code automation
* High Availability design principles

---

# 18. Final Outcome

By the end of Day 14:

* I gained a deep understanding of DNS resolution mechanics.
* I understood VPN connectivity models in Azure.
* I differentiated Load Balancer and Traffic Manager services.
* I implemented a High Availability architecture using ARM.
* I validated traffic distribution behavior.
* I reinforced Infrastructure as Code deployment practices.

---

# 19. Conclusion

Day 14 strengthened both theoretical and practical cloud networking knowledge.

Understanding DNS and VPN fundamentals provides clarity on how internet traffic reaches cloud workloads.

Implementing Azure Load Balancer using ARM Template demonstrated real-world high availability architecture design.

This session significantly enhanced my capability to design scalable, resilient, and production-ready Azure networking solutions.

```
```
