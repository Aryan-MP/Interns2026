```markdown
# Day 3 – 3-Tier Architecture Deployment Using ARM Template

**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of Day 3 was to design and deploy a **3-Tier Architecture** in Microsoft Azure using **ARM Templates (Infrastructure as Code)**.

The focus areas were:

- Understanding 3-tier architecture design
- Deploying Web, App, and DB tiers
- Implementing network separation
- Using ARM Template for automation
- Troubleshooting Azure disk deletion errors

This lab introduced structured enterprise application architecture.

---

# 2. What is 3-Tier Architecture?

A 3-tier architecture separates an application into three logical layers:

1. Web Tier (Presentation Layer)
2. Application Tier (Business Logic Layer)
3. Database Tier (Data Layer)

Each tier has a specific responsibility.

---

# 3. Real-Life Example

Think of a restaurant:

```

Customer → Waiter → Kitchen → Storage Room

```

Mapping to cloud:

- Waiter → Web Tier  
- Kitchen → App Tier  
- Storage Room → Database Tier  

The customer does not directly enter the kitchen or storage room.

Similarly:

- Users interact only with Web Tier.
- Web Tier communicates with App Tier.
- App Tier communicates with Database Tier.

This separation improves:

- Security
- Scalability
- Maintainability

---

# 4. Architecture Design

## 4.1 Logical Architecture

```

Internet
↓
Web Tier (Frontend VM)
↓
App Tier (Application VM)
↓
DB Tier (Database VM)

```

---

## 4.2 Network Segmentation

Each tier is deployed in a separate subnet:

| Tier | Subnet | Purpose |
|------|--------|----------|
| Web | Public Subnet | Internet-facing |
| App | Private Subnet | Internal logic |
| DB  | Private Subnet | Secure data layer |

This ensures isolation between layers.

---

# 5. Components Deployed

Using ARM Template, the following resources were created:

- Virtual Network
- Three Subnets
- Network Security Groups (NSGs)
- Three Virtual Machines:
  - Web VM
  - App VM
  - DB VM
- Public IP (for Web Tier only)
- Network Interfaces
- OS Disks

---

# 6. Tier-Level Responsibilities

## 6.1 Web Tier (Frontend VM)

Purpose:

- Handles HTTP/HTTPS requests
- Serves UI or frontend application
- Accepts internet traffic

Security:

- Allows inbound port 80 / 443
- Does not access DB directly

---

## 6.2 App Tier (Application VM)

Purpose:

- Contains business logic
- Processes requests from Web Tier
- Communicates with Database Tier

Security:

- No public IP
- Only accessible from Web Tier subnet

---

## 6.3 Database Tier (DB VM)

Purpose:

- Stores application data
- Handles SQL queries
- Maintains persistence

Security:

- No public access
- Accessible only from App Tier
- Strict NSG rules

---

# 7. ARM Template Usage

The entire infrastructure was deployed using ARM Template.

Benefits:

- Infrastructure as Code (IaC)
- Repeatable deployments
- Version control
- Reduced manual errors
- Automated provisioning

ARM Template defined:

- Resource dependencies using `dependsOn`
- Network configurations
- VM sizes
- OS configurations

---

# 8. Error Handling – Disk Deletion Issue

While cleaning up resources, an error occurred:

> Disk cannot be deleted because it is attached to a Virtual Machine.

This happens because:

- Azure does not allow deletion of managed disks attached to running or existing VMs.
- Disk must be detached first.

---

## 8.1 Why This Happens

Each VM has:

- OS Disk
- Optional Data Disks

These disks are locked while the VM exists.

If you try to delete the disk manually before deleting the VM:

Azure throws an error.

---

## 8.2 Correct Deletion Process

Proper order:

1. Stop VM
2. Delete VM
3. Ensure NIC and Public IP are removed
4. Delete attached disks

Best Practice:

Delete the entire Resource Group to avoid orphan resources.

---

# 9. Enterprise Best Practices Learned

## 9.1 Separation of Concerns

Each tier must have:

- Dedicated subnet
- Dedicated NSG rules
- Restricted access

---

## 9.2 No Direct Internet Access to DB

Database tier should never:

- Have public IP
- Allow inbound internet traffic

---

## 9.3 Infrastructure as Code

Manual deployment leads to:

- Inconsistent environments
- Configuration mistakes

ARM ensures:

- Repeatability
- Auditability
- Scalability

---

# 10. Architectural Insight

3-tier architecture improves:

- Security
- Scalability
- Performance isolation
- Fault isolation

If one tier fails:

- Others can remain operational
- Scaling can be done independently

Example:

- Scale Web Tier during high traffic
- Keep DB Tier constant

This is common in:

- E-commerce applications
- Enterprise web applications
- SaaS platforms

---

# 11. Key Concepts Learned

- 3-tier architecture fundamentals
- Subnet segmentation strategy
- NSG rule design
- VM-to-VM communication control
- ARM Template dependency handling
- Managed disk lifecycle
- Azure resource cleanup best practices
- Enterprise network isolation model

---

# 12. Final Outcome

By the end of Day 3:

- I deployed a complete 3-tier architecture using ARM.
- I understood tier separation and network isolation.
- I handled Azure disk deletion errors correctly.
- I applied Infrastructure as Code principles.
- I strengthened enterprise-level architecture understanding.

---

# 13. Conclusion

Day 3 introduced structured enterprise application architecture using Azure.

Deploying a 3-tier model using ARM Templates demonstrated:

- Scalable system design
- Secure tier communication
- Infrastructure automation
- Production-level cloud architecture thinking

This lab significantly enhanced my cloud architecture and troubleshooting skills.
```

---
