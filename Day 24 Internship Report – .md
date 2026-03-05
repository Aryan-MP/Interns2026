**Internship Report – Day 24**  
**Topic:** Advanced AWS Networking (VPC, Subnets, Internet Gateway) and AWS IAM Roles

---

# **1\. Introduction**

On the **24th day of my internship**, the session focused on **advanced cloud networking concepts in AWS** and **AWS Identity and Access Management (IAM) Roles**.

The first half of the session covered networking topics such as:

* Virtual Networks (VNet concept comparison)  
* AWS Virtual Private Cloud (VPC)  
* Subnets and their types  
* Route Tables  
* Internet Gateway  
* Secure instance connectivity

In the second part of the session, we studied **AWS IAM Roles in detail**, including how roles are used for **secure access between AWS services, applications, and accounts**.

We also performed practical tasks involving **EC2 instances inside public and private subnets** and installed server tools on a private instance.

---

# **2\. Virtual Networking Concept**

A **Virtual Network** is a logically isolated network created in a cloud environment where resources communicate securely.

Different cloud providers use different names for virtual networks:

| Cloud Provider | Virtual Network Service |
| ----- | ----- |
| AWS | VPC (Virtual Private Cloud) |
| Azure | VNet (Virtual Network) |
| Google Cloud | VPC Network |

Although the terminology differs, the purpose is the same: **creating a private, secure cloud network for resources**.

---

# **3\. AWS VPC (Virtual Private Cloud)**

An **AWS VPC** is a logically isolated network inside AWS where users can launch cloud resources such as EC2 instances, databases, and load balancers.

Key features of AWS VPC include:

* Custom **IP address ranges (CIDR blocks)**  
* Creation of **multiple subnets**  
* Custom **route tables**  
* Secure access using **security groups**  
* Internet connectivity using **Internet Gateway**

A VPC provides **complete control over network configuration**, similar to managing a traditional data center network.

---

# **4\. Subnets in AWS**

A **Subnet** divides the VPC network into smaller network segments.

Subnets help organize resources and control network access.

### **Types of Subnets**

#### **Public Subnet**

A **public subnet** allows instances to communicate with the internet.

Characteristics:

* Connected to an **Internet Gateway**  
* Instances have **public IP addresses**  
* Commonly used for:  
  * Web servers  
  * Bastion hosts  
  * Load balancers

---

#### **Private Subnet**

A **private subnet** does not allow direct internet access.

Characteristics:

* No route to the Internet Gateway  
* Used for secure backend resources like:  
  * Databases  
  * Internal application servers  
  * Microservices

Using both types creates a **secure multi-tier architecture**.

---

# **5\. Internet Gateway (IGW)**

An **Internet Gateway** is a component that allows communication between a **VPC and the internet**.

Functions:

* Allows instances in public subnets to access the internet  
* Enables inbound and outbound internet traffic

To enable internet access:

1. Attach the Internet Gateway to the VPC.  
2. Add a route in the route table (`0.0.0.0/0 → IGW`).  
3. Assign a public IP to the instance.

---

# **6\. Route Tables**

A **Route Table** defines how traffic moves between networks.

Each route table contains rules specifying:

* **Destination network**  
* **Target gateway or resource**

Example:

| Destination | Target |
| ----- | ----- |
| VPC CIDR | Local |
| 0.0.0.0/0 | Internet Gateway |

Route tables ensure correct traffic flow between **subnets, internet, and internal resources**.

---

# **7\. Practical Task 1 – Public and Private EC2 Connectivity**

The first lab task involved creating two EC2 instances:

1. One in a **Public Subnet**  
2. One in a **Private Subnet**

The goal was to connect the private instance using the public instance as an intermediate server.

This architecture is known as a **Bastion Host Architecture**.

---

### **Step 1 – Create VPC**

1. Open AWS Console  
2. Go to **VPC Service**  
3. Click **Create VPC**  
4. Provide CIDR block (example `10.0.0.0/16`)

---

### **Step 2 – Create Subnets**

Create two subnets:

Public Subnet  
Example CIDR: `10.0.1.0/24`

Private Subnet  
Example CIDR: `10.0.2.0/24`

---

### **Step 3 – Create Internet Gateway**

1. Create Internet Gateway  
2. Attach it to the VPC

---

### **Step 4 – Configure Route Table**

Add route:

Destination: 0.0.0.0/0  
Target: Internet Gateway

Associate the route table with the **public subnet**.

---

### **Step 5 – Launch EC2 Instances**

**Public Instance**

* Subnet: Public Subnet  
* Public IP enabled  
* Security group allowing SSH

**Private Instance**

* Subnet: Private Subnet  
* No public IP  
* SSH allowed only from public instance security group

---

### **Step 6 – Connect to Public Instance**

ssh \-i key.pem ec2-user@public-ip

---

### **Step 7 – Connect to Private Instance**

From the public instance:

ssh \-i key.pem ec2-user@private-ip

This ensures the private instance is **not directly accessible from the internet**.

---

# **8\. Practical Task 2 – Installing Software on Private Instance**

After accessing the private EC2 instance, we installed several tools.

---

### **Update System**

sudo yum update \-y

---

### **Install Apache (HTTPD)**

sudo yum install httpd \-y  
sudo systemctl start httpd  
sudo systemctl enable httpd

---

### **Install Nginx**

sudo amazon-linux-extras install nginx1 \-y  
sudo systemctl start nginx  
sudo systemctl enable nginx

---

### **Install Python**

sudo yum install python3 \-y  
python3 \--version

---

### **Install Git**

sudo yum install git \-y  
git \--version

These tools are commonly used for **web hosting, development, and automation tasks**.

---

# **9\. AWS IAM Roles (Detailed Overview)**

We also studied **AWS IAM Roles** in detail.

### **What is an IAM Role?**

An **IAM Role** is an AWS identity that provides temporary permissions to users, applications, or services to access AWS resources.

Unlike IAM users, roles **do not have permanent credentials** such as passwords or access keys.

Instead, roles provide **temporary security credentials**.

---

### **Key Characteristics of IAM Roles**

* No long-term credentials  
* Temporary access permissions  
* Used by AWS services, applications, and users  
* Helps implement **least privilege access**

Roles are widely used for **secure service-to-service communication**.

---

### **Components of an IAM Role**

1. **Trust Policy**

Defines **who can assume the role**.

Example:

Service: EC2  
Action: sts:AssumeRole

This means EC2 instances can use the role.

---

2. **Permission Policy**

Defines **what actions the role can perform**.

Example:

* Access S3  
* Write logs to CloudWatch  
* Read DynamoDB tables

---

# **10\. Common Use Cases of IAM Roles**

### **EC2 Instance Role**

Allows an EC2 instance to access AWS services securely.

Example:

* EC2 accessing S3 buckets  
* EC2 sending logs to CloudWatch

This avoids storing **access keys inside the instance**.

---

### **Cross Account Role**

Allows users from one AWS account to access resources in another account.

Example:

* Dev account accessing logs in Prod account

---

### **Service Roles**

Roles used by AWS services.

Examples:

* Lambda execution role  
* ECS task role  
* CloudFormation service role

---

### **Federated Access Role**

Allows external users from:

* Google  
* Microsoft Azure AD  
* SAML identity providers

to access AWS resources without creating IAM users.

---

# **11\. Architecture Implemented**

The networking architecture built during the lab was:

Internet  
   │  
Internet Gateway  
   │  
Public Subnet  
   │  
Public EC2 (Bastion Host)  
   │  
Private Subnet  
   │  
Private EC2 (Application Server)

This architecture is widely used in **secure production environments**.

---

# **12\. Day 24 Learnings**

From today's session, I learned:

* Deep networking concepts in **AWS VPC**  
* Differences between **public and private subnets**  
* Role of **Internet Gateway and Route Tables**  
* Secure EC2 connectivity using a **bastion host**  
* Installing and configuring **server software on Linux EC2**  
* Understanding **AWS IAM Roles and temporary credentials**  
* Secure access between **AWS services and resources**

This session strengthened my understanding of **cloud networking architecture and identity management**, which are important skills for **cloud engineers, DevOps engineers, and cloud security professionals**.

