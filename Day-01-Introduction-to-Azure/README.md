
# ☁️ Day 1 – Introduction to Cloud Computing & Microsoft Azure

## 🏢 Platform: Microsoft Azure

---
## 🎯 Objective

The objective of Day 1 was to understand the fundamentals of **Cloud Computing** and get familiar with the Azure ecosystem, including core services and tools used by cloud engineers.

---

# 📝 Topics Covered

1. Introduction to Cloud Computing
2. Creating Azure Account
3. Azure Portal Overview
4. Resource Groups
5. Virtual Machines (VM)
6. Azure Storage
7. Azure Networking Basics
8. Identity & Access Management (IAM)
9. Azure CLI
10. ARM Templates

---

# 1️⃣ Introduction to Cloud Computing

## 📖 What is Cloud Computing?

Cloud Computing is the delivery of computing services such as:

* Servers
* Storage
* Databases
* Networking
* Software

Over the internet ("the cloud") instead of using local servers.

## 🔹 Cloud Service Models

* **IaaS (Infrastructure as a Service)** – Virtual machines, storage, networking
* **PaaS (Platform as a Service)** – App hosting environment
* **SaaS (Software as a Service)** – Software delivered over internet

## 🔹 Cloud Deployment Models

* Public Cloud
* Private Cloud
* Hybrid Cloud

---

# 2️⃣ Creating Azure Free Account

## 📝 Task

* Sign up for Azure Free Account
* Explore subscription details

## 🔧 Steps Performed

1. Visited Azure official website
2. Signed up using email
3. Verified identity
4. Activated free subscription

## 🧠 Learning

* Azure provides free credits for learning
* Subscription is required to create resources

---

# 3️⃣ Azure Portal Overview

## 📖 What is Azure Portal?

Azure Portal is a web-based interface used to manage Azure resources.

## 🔧 Explored Sections:

* Dashboard
* Resource Groups
* Virtual Machines
* Storage Accounts
* Networking
* Subscriptions

## 🧠 Learning

* Portal provides GUI-based resource management
* Resources are searchable from the top search bar
* Monitoring and billing are accessible from portal

---

# 4️⃣ Resource Groups

## 📖 What is a Resource Group?

A Resource Group is a container that holds related Azure resources.

## 📝 Task

* Create a new Resource Group

## 🔧 Steps

1. Go to **Resource Groups**
2. Click **Create**
3. Enter:

   * Subscription
   * Resource Group Name
   * Region
4. Click **Review + Create**

## 🧠 Learning

* All resources must belong to a resource group
* Helps in managing, monitoring, and deleting resources together

---

# 5️⃣ Virtual Machines (VM)

## 📖 What is a Virtual Machine?

A VM is a virtual server that runs an operating system.

## 📝 Task

* Create a basic Virtual Machine

## 🔧 Basic Configuration:

* Resource Group
* VM Name
* Region
* Image (Windows/Linux)
* Size (CPU/RAM)
* Authentication (Password/SSH)

## 🧠 Learning

* VM requires networking and storage to function
* Public IP allows remote access
* NSG controls traffic

---

# 6️⃣ Azure Storage

## 📖 What is Azure Storage?

Azure Storage provides scalable cloud storage solutions.

## 🔹 Types of Storage:

* Blob Storage (Unstructured Data)
* File Storage
* Queue Storage
* Table Storage

## 🧠 Learning

* Blob storage is commonly used for images & backups
* Storage accounts must be globally unique

---

# 7️⃣ Azure Networking Basics

## 📖 Core Components:

* Virtual Network (VNet)
* Subnet
* Public IP
* Network Security Group (NSG)

## 🧠 Learning

* VNet allows communication between resources
* Subnets divide network into smaller segments
* NSG controls inbound/outbound traffic

---

# 8️⃣ Identity & Access Management (IAM)

## 📖 What is IAM?

IAM controls who can access Azure resources.

## 🔹 Key Concepts:

* Users
* Roles
* Role-Based Access Control (RBAC)

## 🧠 Learning

* Owner – Full access
* Contributor – Manage resources
* Reader – View only

Security is critical in cloud environments.

---

# 9️⃣ Azure CLI

## 📖 What is Azure CLI?

Azure CLI is a command-line tool used to manage Azure resources.

## 💻 Example Command:

```bash
az login
```

Login to Azure account.

```bash
az group create --name MyResourceGroup --location eastus
```

Create a Resource Group using CLI.

## 🧠 Learning

* CLI is faster for automation
* Useful for scripting and DevOps

---

# 🔟 ARM Templates

## 📖 What are ARM Templates?

ARM (Azure Resource Manager) Templates are JSON files used to deploy infrastructure as code.

## 💻 Basic Structure:

```json
{
  "$schema": "...",
  "contentVersion": "1.0.0.0",
  "resources": []
}
```

## 🧠 Learning

* Enables Infrastructure as Code (IaC)
* Automates deployments
* Ensures consistent environment setup

---

# 🚀 Key Takeaways from Day 1

* Understood cloud computing fundamentals
* Learned core Azure services
* Created and managed resources
* Explored GUI and CLI methods
* Understood importance of security and networking

---

# ✅ Conclusion

Day 1 provided a strong foundation in cloud computing concepts and core Azure services. I gained hands-on exposure to resource management, virtual machines, storage, networking, IAM, CLI commands, and infrastructure as code using ARM templates.

This sets the base for deeper cloud engineering tasks in upcoming days.

---
