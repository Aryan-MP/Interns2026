**Internship Report – Day 21**  
**Topic:** Introduction to AWS and AWS Organizations

---

## **1\. Overview of AWS**

On the 21st day of my internship, we began learning about **Amazon Web Services (AWS)** and its basic structure for managing cloud resources and accounts.

**AWS (Amazon Web Services)** is a cloud computing platform provided by **Amazon** that offers a wide range of services such as computing power, storage, networking, databases, security, analytics, and machine learning. Instead of purchasing physical servers or infrastructure, organizations can use AWS to deploy and manage applications through the internet.

AWS follows a **pay-as-you-go model**, meaning users only pay for the services they consume. It also provides a **Free Tier** that allows beginners to learn and experiment with cloud services at minimal or zero cost.

Some key advantages of AWS include:

* **Scalability:** Resources can be increased or decreased depending on demand.  
* **High Availability:** Services are distributed across multiple regions and availability zones.  
* **Security:** Built-in tools like IAM, encryption, and monitoring services help secure resources.  
* **Global Infrastructure:** AWS data centers exist worldwide for better performance and redundancy.

---

# **2\. Types of AWS Accounts**

During the session, we learned about the **types of AWS accounts** used in organizations.

### **AWS Standalone Account**

A **Standalone Account** is the AWS account that any user creates using their own email ID and credentials.

Characteristics:

* Managed independently.  
* Not part of any AWS organization.  
* The account owner manages billing, resources, IAM users, and permissions.

If a user wants to manage multiple AWS accounts under one structure, the standalone account can be converted into an **AWS Organization**.

---

# **3\. AWS Organizations**

**AWS Organizations** is a service that allows companies to manage multiple AWS accounts centrally.

It helps organizations:

* Centrally manage multiple accounts.  
* Apply security policies.  
* Control billing and cost management.  
* Organize accounts into groups.

### **AWS Organization Hierarchy**

AWS Organization  
│  
├── Management Account (Parent / Root of Organization)  
│   │  
│   ├── IAM User (Admin)  
│   │  
│   └── Organization Root  
│  
└── Organizational Unit (OU)  
    │  
    ├── Member Account 1  
    │   └── IAM users / roles / resources  
    │  
    └── Member Account 2  
        └── IAM users / roles / resources

From the above hierarchy, we can understand how AWS manages multiple accounts within an organization.

* The **Management Account** sits at the top.  
* Under it are **Organizational Units (OUs)**.  
* Each OU contains multiple **Member Accounts**.

Each **member account** can have its own IAM users, roles, and resources, but the overall organization is controlled by the **management account**.

---

# **4\. Root Account**

The **Root Account** is the original account created when registering with AWS.

Characteristics:

* It has **full administrative access** to all AWS services.  
* It can perform **any action without restriction**.  
* Used for critical tasks such as:  
  * Changing account settings  
  * Managing billing  
  * Enabling MFA  
  * Creating or removing member accounts  
  * Managing AWS organizations

Because of its powerful permissions, the root account should **not be used for daily operations**. Instead, an **IAM admin user** should be created for regular work.

---

# **5\. Management Account**

The **Management Account** is the AWS account that creates and controls an AWS Organization.

Functions of the Management Account:

* Creates and manages **member accounts**  
* Organizes accounts into **Organizational Units (OUs)**  
* Manages **organization-wide billing**  
* Creates and applies **Service Control Policies (SCPs)**  
* Monitors account activity

Important note:  
The **Management Account usually does not deploy resources**, but instead manages the entire organization structure and policies.

---

# **6\. Organizational Unit (OU)**

An **Organizational Unit (OU)** is a logical container used to group AWS accounts inside an organization.

Purpose of OUs:

* Organize accounts based on departments or environments.  
* Apply security policies to multiple accounts at once.  
* Simplify management of large organizations.

Example OU structure:

Organization  
│  
├── OU: Development  
│   ├── Dev Account 1  
│   └── Dev Account 2  
│  
├── OU: Testing  
│   └── Test Account  
│  
└── OU: Production  
    └── Production Account

This structure helps administrators apply policies and manage resources efficiently.

---

# **7\. Member Account**

A **Member Account** is a standard AWS account that belongs to an AWS Organization.

Characteristics:

* Used to deploy and manage **actual cloud resources**.  
* Can have its own **IAM users, roles, and services**.  
* Cannot manage the organization itself.  
* Controlled by policies defined by the **management account**.

Limitations:

* Cannot create other member accounts.  
* Cannot manage organizational units.  
* Cannot modify Service Control Policies.

---

# **8\. AWS Budget Types**

We also learned about different types of **AWS budgets**, which help control cloud spending.

### **1\. Zero Spend Budget**

A **Zero Spend Budget** is set at **$0**.

Purpose:

* Ensures that the account stays within the **AWS Free Tier**.  
* Sends alerts if any cost is generated.

---

### **2\. Monthly Cost Budget**

This budget tracks the **total monthly AWS spending**.

Features:

* User defines a **spending limit**.  
* AWS tracks the actual cost.  
* Can predict future spending using **forecast cost analysis**.

---

### **3\. Daily Savings Plans Coverage Budget**

Savings Plans offer discounts when users commit to a certain level of usage.

Coverage measures:

* How much of your AWS workload is using the **discounted savings plan**.  
* Helps determine whether resources are fully benefiting from the plan.

---

### **4\. Daily Reservation Utilization Budget**

Reserved Instances are like prepaid cloud capacity.

This budget tracks:

* Whether the reserved capacity is actually being used.  
* Helps avoid paying for unused reservations.

---

# **9\. Service Control Policy (SCP)**

A **Service Control Policy (SCP)** is an organization-level guardrail that defines the **maximum permissions an AWS account can have**.

Key points:

* Applied at:  
  * Organization Root  
  * Organizational Units  
  * Member Accounts  
* Controls which **AWS services and actions** can be used.  
* Can restrict **regions or conditions**.

Important characteristics:

* **SCPs do NOT grant permissions**  
* They **limit permissions**

Permission evaluation example:

IAM allows  \+ SCP allows  \= ALLOWED  
IAM allows  \+ SCP denies  \= DENIED  
IAM denies  \+ SCP allows  \= DENIED

---

# **10\. Resource Control Policy (RCP)**

A **Resource Control Policy (RCP)** is an organization-level policy that controls access to **AWS resources** across the organization.

Purpose:

* Protect resources regardless of which account is making the request.

Features:

* Applies to:  
  * Organization Root  
  * Organizational Units  
  * Member Accounts  
  * Resources  
* Restricts:  
  * Cross-account access  
  * External access outside the organization  
* Adds a **mandatory deny layer** on resources.

Important notes:

* Does **not grant permissions**.  
* Does **not replace resource policies**.  
* Does **not override explicit denies**.

RCPs exist because:

* SCPs control **identities**  
* Resource policies control **resources**  
* RCP provides **organization-wide resource protection**

---

# **11\. IAM (Identity and Access Management) Policy**

An **IAM Policy** defines what an identity (user, role, or service) is allowed or denied to do.

Unlike SCPs and RCPs, **IAM policies actually grant permissions**.

IAM policies can:

* Allow or deny **API actions**  
* Control access to **AWS services**  
* Restrict actions on **specific resources**

Types of IAM policies:

1. **Identity-Based Policies**  
   Attached to users, roles, or groups.  
2. **Resource-Based Policies**  
   Attached directly to AWS resources.  
3. **Permission Boundaries**  
   Define the maximum permissions an IAM entity can have.  
4. **Session Policies**  
   Temporary policies applied during a session.

---

# **12\. Day 21 Learnings**

From today's session, I gained a clear understanding of:

* The **basic structure of AWS cloud services**.  
* The difference between **Standalone Accounts and Organizational Accounts**.  
* How **AWS Organizations manages multiple accounts** efficiently.  
* The roles of **Root Account, Management Account, Organizational Units, and Member Accounts**.  
* The importance of **AWS budgets** for cost monitoring.  
* How **SCPs, RCPs, and IAM policies** control permissions and security within AWS environments.

This session helped build a strong foundation for understanding **AWS account governance, security, and cost management**, which are essential for designing and managing secure cloud architectures.

---

