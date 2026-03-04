# ☁️ Azure Cloud Internship – Day 2

## 📚 Core Azure Architecture & Identity Concepts

---

# 🎯 Objective

The objective of Day 2 was to understand the **core architectural structure of Azure**, identity management, compute, storage, networking, and high availability concepts.

This session focused on building strong foundational knowledge required for designing cloud infrastructure.

---

# 📝 Topics Covered

1. Tenant
2. Entra ID
3. Azure Resource Manager (ARM)
4. Azure Compute
5. Azure Storage
6. Azure Hierarchy
7. Azure Networking
8. Fault Domain
9. Update Domain

---

# 1️⃣ Tenant in Azure

## 📖 What is a Tenant?

A **Tenant** represents a dedicated and trusted instance of Azure Active Directory (now Entra ID) for an organization.

* It is created when an organization signs up for Azure.
* It contains users, groups, applications, and service principals.
* Each tenant has a unique Tenant ID.

## 🧠 Key Understanding

* One organization = One Tenant (generally)
* A tenant can have multiple subscriptions.
* Identity management is controlled at the tenant level.

---

# 2️⃣ Microsoft Entra ID

## 📖 What is Entra ID?

Microsoft Entra ID is Azure’s Identity and Access Management (IAM) service.

It helps manage:

* Users
* Groups
* Roles
* Authentication
* Authorization

## 🔐 Features

* Role-Based Access Control (RBAC)
* Multi-Factor Authentication (MFA)
* Single Sign-On (SSO)

## 🧠 Learning Outcome

Identity is the security foundation of cloud environments.
Access to resources is controlled using Entra ID roles and permissions.

---

# 3️⃣ Azure Resource Manager (ARM)

## 📖 What is ARM?

Azure Resource Manager (ARM) is the deployment and management service for Azure.

It allows you to:

* Create
* Update
* Delete
* Organize resources

## 🔹 Key Functions

* Manages resources using **Resource Groups**
* Supports Infrastructure as Code (ARM Templates)
* Provides centralized management layer

## 🧠 Learning

All resources in Azure are deployed and managed through ARM.

---

# 4️⃣ Azure Compute

## 📖 What is Azure Compute?

Azure Compute provides on-demand computing resources such as:

* Virtual Machines (VMs)
* Virtual Machine Scale Sets
* App Services
* Kubernetes Services

## 🧠 Key Points

* Compute resources run applications and workloads.
* VM size determines CPU, RAM, and performance.
* Scale sets help in auto-scaling.

---

# 5️⃣ Azure Storage

## 📖 What is Azure Storage?

Azure Storage provides scalable and durable storage solutions.

### 🔹 Types:

* Blob Storage (unstructured data)
* File Storage
* Queue Storage
* Table Storage
* Disk Storage (for VMs)

## 🧠 Learning

Storage accounts must be:

* Globally unique
* Linked to a region
* Associated with a resource group

---

# 6️⃣ Azure Hierarchy

## 📖 Azure Organizational Structure

Azure follows a hierarchical structure:

```
Management Group
   ↓
Subscription
   ↓
Resource Group
   ↓
Resources
```

## 🔹 Explanation

* **Management Group** – Organizes multiple subscriptions
* **Subscription** – Billing boundary
* **Resource Group** – Logical container
* **Resources** – Actual services (VM, Storage, etc.)

## 🧠 Learning

Hierarchy helps in:

* Governance
* Policy Management
* Cost Control
* Access Control

---

# 7️⃣ Azure Networking

## 📖 Core Networking Components

* Virtual Network (VNet)
* Subnet
* Network Security Group (NSG)
* Public IP
* Load Balancer

## 🧠 Key Understanding

* VNet enables communication between resources.
* NSG controls inbound and outbound traffic.
* Subnets logically divide the network.

Networking ensures secure and controlled communication.

---

# 8️⃣ Fault Domain

## 📖 What is a Fault Domain?

A Fault Domain is a logical grouping of hardware that shares a common power source and network switch.

If one fault domain fails:

* Other fault domains remain unaffected.

## 🧠 Importance

Provides **high availability** and protects against hardware failure.

---

# 9️⃣ Update Domain

## 📖 What is an Update Domain?

An Update Domain is a logical group of virtual machines that are rebooted together during planned maintenance.

* Azure updates one update domain at a time.
* Prevents all VMs from restarting simultaneously.

## 🧠 Importance

Ensures application availability during maintenance.

---

# 🚀 Key Takeaways from Day 2

* Understood Azure identity structure (Tenant & Entra ID)
* Learned Azure management hierarchy
* Explored compute and storage services
* Understood networking basics
* Learned high availability concepts (Fault & Update Domains)

---


# ✅ Conclusion

Day 2 focused on understanding Azure’s internal structure, identity system, and core infrastructure services.
These concepts form the backbone of cloud architecture design and are essential for deploying secure, scalable, and highly available solutions in Azure.

---
