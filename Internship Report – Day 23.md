**Internship Report – Day 23**  
**Topic:** AWS VPC Networking Fundamentals and IAM Policy Configuration

---

# **1\. Introduction**

On the **23rd day of my internship**, the session focused on **AWS networking fundamentals** and **policy-based access control in AWS**. In the first half of the session, we studied **Amazon Virtual Private Cloud (VPC)** and its core networking components such as **subnets, route tables, internet gateways, and security groups**.

In the second half of the session, we worked on **IAM policy configurations** that enforce **region restrictions and resource usage limits**, which are important concepts in **cloud governance and security management**.

---

# **2\. Overview of AWS VPC**

**Amazon Virtual Private Cloud (VPC)** is a networking service that allows users to create a **private virtual network within AWS**. It enables organizations to deploy AWS resources such as EC2 instances, databases, and load balancers inside an isolated network environment.

Key features of VPC include:

* Full control over **IP addressing**  
* Ability to create **subnets**  
* Custom **route tables**  
* Secure connectivity using **security groups and network ACLs**  
* Connectivity to the internet using **Internet Gateway**

A VPC acts similar to a **traditional data center network**, but it is fully managed in the cloud.

---

# **3\. Subnets and Their Types**

A **subnet** is a logical subdivision of a VPC's IP address range. It allows users to organize resources and control network access.

### **Types of Subnets**

**1\. Public Subnet**

A public subnet is a subnet that has access to the **Internet through an Internet Gateway**.

Characteristics:

* Instances can communicate with the internet.  
* Typically used for:  
  * Web servers  
  * Load balancers  
  * Bastion hosts

**2\. Private Subnet**

A private subnet does **not have direct internet access**.

Characteristics:

* Instances cannot directly communicate with the internet.  
* Used for secure resources such as:  
  * Databases  
  * Backend services  
  * Application servers

Using public and private subnets together helps create a **secure multi-tier architecture**.

---

# **4\. Route Tables**

A **Route Table** is a set of rules that determines how network traffic is directed within a VPC.

Each route table contains:

* **Destination** – The IP range where traffic should go.  
* **Target** – The gateway or resource where the traffic should be routed.

Example routes:

| Destination | Target |
| ----- | ----- |
| VPC CIDR | Local |
| 0.0.0.0/0 | Internet Gateway |

Route tables allow administrators to control **how traffic flows between subnets and external networks**.

---

# **5\. Internet Gateway**

An **Internet Gateway (IGW)** is a component that allows communication between the **VPC and the internet**.

Key points:

* Attached to a VPC  
* Enables resources in **public subnets** to access the internet  
* Works together with **route tables**

Without an Internet Gateway, instances inside a VPC **cannot access external networks**.

---

# **6\. Security Groups**

A **Security Group** acts as a **virtual firewall for EC2 instances**.

Security groups control **inbound and outbound traffic** to resources.

Characteristics:

* **Stateful firewall**  
* Rules allow traffic based on:  
  * Protocol  
  * Port number  
  * Source/Destination

Example rules:

| Type | Port | Source |
| ----- | ----- | ----- |
| SSH | 22 | Admin IP |
| HTTP | 80 | 0.0.0.0/0 |
| HTTPS | 443 | 0.0.0.0/0 |

Security groups help protect AWS resources by **restricting unnecessary network access**.

---

# **7\. Practical Task – Creating a VPC and Its Components**

During the lab session, we were assigned a practical task to **create a VPC and configure its networking components**.

The steps performed included:

1. Creating a **custom VPC** with a defined CIDR block.  
2. Creating **subnets inside the VPC**.  
3. Configuring **route tables**.  
4. Attaching an **Internet Gateway** to enable external connectivity.  
5. Associating route tables with subnets.  
6. Configuring **security groups** to control traffic to EC2 instances.

This hands-on activity helped in understanding how AWS networking components work together to form a **secure and functional cloud network architecture**.

---

# **8\. Policy Task – Region Restriction Policy**

In the second half of the session, we worked with **IAM policies** designed to enforce **region restrictions and controlled access**.

### **Policy Purpose**

The first policy was designed to:

* **Deny all AWS actions outside approved regions**  
* Allow **read-only access inside approved regions**

Approved regions:

* us-east-1  
* us-east-2

### **Policy Behavior**

The policy contains two statements:

**Statement 1 – Deny outside approved regions**

{  
 "Sid": "DenyAllOutsideApprovedRegions",  
 "Effect": "Deny",  
 "Action": "\*",  
 "Resource": "\*",  
 "Condition": {  
  "StringNotEquals": {  
   "aws:RequestedRegion": \[  
    "us-east-1",  
    "us-east-2"  
   \]  
  }  
 }  
}

This rule blocks **all actions** if a request is made outside the approved regions.

---

**Statement 2 – Allow read-only actions in approved regions**

{  
 "Sid": "AllowReadOnlyInsideApprovedRegions",  
 "Effect": "Allow",  
 "Action": \[  
  "ec2:Describe\*",  
  "rds:Describe\*",  
  "lambda:Get\*",  
  "lambda:List\*",  
  "iam:Get\*",  
  "iam:List\*",  
  "s3:Get\*",  
  "s3:List\*"  
 \],  
 "Resource": "\*",  
 "Condition": {  
  "StringEquals": {  
   "aws:RequestedRegion": \[  
    "us-east-1",  
    "us-east-2"  
   \]  
  }  
 }  
}

This allows users to **view resources but not modify them** in approved regions.

### **Purpose**

* Enforce **regional compliance**  
* Prevent deployment in unauthorized regions  
* Allow **safe read-only monitoring access**

---

# **9\. Policy Task – Resource Restrictions for EC2 and IAM**

The second policy applied **restrictions on EC2 resources and IAM role usage**.

### **EC2 Restrictions**

The policy allows EC2 operations only under specific conditions:

* Instance types allowed:  
  * **t2.micro**  
  * **t2.nano**  
* Volume type allowed:  
  * **gp2**  
* Maximum volume size:  
  * **30 GB**  
* Allowed region:  
  * **us-east-1**

Example condition logic:

"Condition": {  
 "StringEquals": {  
  "ec2:VolumeType": "gp2",  
  "ec2:InstanceType": \[  
   "t2.micro",  
   "t2.nano"  
  \],  
  "aws:RequestedRegion": "us-east-1"  
 },  
 "NumericLessThanEquals": {  
  "ec2:VolumeSize": "30"  
 }  
}

### **IAM Role Management**

The policy also allowed controlled IAM operations such as:

* Creating roles  
* Attaching policies  
* Passing roles to services

Example allowed services for **PassRole**:

* Lambda  
* S3

"iam:PassedToService": \[  
 "lambda.amazonaws.com",  
 "s3.amazonaws.com"  
\]

### **Purpose**

These restrictions ensure:

* Only **free-tier friendly instance types are used**  
* Resources remain **cost-controlled**  
* IAM roles are used only by **approved services**

---

# **10\. Day 23 Learnings**

From today's session, I learned:

* The architecture and components of **AWS Virtual Private Cloud (VPC)**.  
* The difference between **public and private subnets**.  
* How **route tables and internet gateways manage network traffic**.  
* The importance of **security groups for instance-level protection**.  
* How IAM policies can enforce **region restrictions**.  
* How to restrict **EC2 instance types, volume sizes, and services using policy conditions**.  
* The use of **IAM PassRole for service integrations**.

Overall, this session helped strengthen my understanding of **AWS networking architecture and security policy enforcement**, which are critical for designing **secure and cost-efficient cloud environments**.

