#  Day-26 Lab

## Topic: EC2 Advanced Configuration, Hibernation, Placement Groups, and Application Load Balancer with Custom Domain

---

#  Objective

In this lab we explored **advanced EC2 configuration options** and implemented a **web application architecture using Application Load Balancer and custom DNS**.

The lab includes:

* EC2 **Hibernation**
* **Placement Groups** in EC2
* EC2 **Advanced Configuration options**
* Deploying a **web application on EC2**
* Creating **Target Groups**
* Configuring **Application Load Balancer (ALB)**
* Using **AWS Certificate Manager**
* Configuring **Route53 DNS**

---

#  EC2 Hibernation

EC2 **Hibernation** allows an instance to **pause and save its RAM state to the EBS root volume**.

When the instance starts again, the RAM state is restored and the instance resumes exactly where it left off.

### Key Points

* Root volume **must be encrypted**
* RAM data is stored in **EBS volume**
* Faster restart compared to normal stop/start
* Useful for **long-running workloads**

### Requirements

| Requirement              | Description                   |
| ------------------------ | ----------------------------- |
| Encrypted Root Volume    | Mandatory                     |
| Supported Instance Types | Only certain EC2 families     |
| RAM Size Limit           | Must be supported by instance |
| Amazon EBS Root Volume   | Required                      |

---

#  EC2 Placement Groups

A **Placement Group** determines how EC2 instances are placed on the underlying hardware.

It helps optimize:

* Network performance
* Latency
* Fault tolerance

---

## Types of Placement Groups

### Cluster Placement Group

Instances are placed **close together in a single Availability Zone**.

Benefits:

* Low network latency
* High throughput

Used for:

* HPC workloads
* Big Data processing
* Distributed computing

Example:

```
Instances → Same Rack → Same AZ
```

---

### Spread Placement Group

Instances are placed **across different hardware racks**.

Benefits:

* Reduced risk of simultaneous failure

Used for:

* Critical workloads
* Applications needing high availability

Limit:

* Maximum **7 instances per AZ**

---

### Partition Placement Group

Instances are divided into **logical partitions**.

Benefits:

* Fault isolation between partitions
* Suitable for distributed systems

Used for:

* Hadoop clusters
* Cassandra
* Kafka clusters

Example:

```
Partition 1 → Rack A
Partition 2 → Rack B
Partition 3 → Rack C
```

---

#  EC2 Advanced Details (During Instance Creation)

While launching an EC2 instance, several **advanced configuration options** are available.

---

## IAM Role

Attach an **IAM role** to allow EC2 to access AWS services.

Examples:

* Access S3
* Send logs to CloudWatch
* Access DynamoDB

---

## User Data

User Data scripts run **during instance boot**.

Example:

```bash
#!/bin/bash
sudo apt update
sudo apt install nginx -y
```

Used for **automated instance setup**.

---

## Shutdown Behavior

Defines instance behavior when OS shutdown command is executed.

Options:

| Option    | Description           |
| --------- | --------------------- |
| Stop      | Instance stops        |
| Terminate | Instance gets deleted |

---

## Termination Protection

Prevents accidental deletion of instances.

---

## Detailed Monitoring

Enables **1-minute CloudWatch metrics** instead of default **5-minute metrics**.

---

## Instance Metadata

Metadata allows instance to retrieve information about itself.

Example:

```
Instance ID
Security Groups
IAM Role
```

---

## Credit Specification

Used for **burstable instances (T2, T3, T4)**.

Modes:

| Mode      | Description                    |
| --------- | ------------------------------ |
| Standard  | Uses CPU credits               |
| Unlimited | Allows bursting beyond credits |

---

#  Task-1: Deploy Web Application with ALB and Custom Domain

---

# Architecture Overview

```
User
 │
 │ HTTPS
 ▼
Application Load Balancer
 │
 ▼
Target Group
 │
 ▼
EC2 Web Server
```

---

# Step-1: Launch EC2 Instance

Launch a VM and install a web application.

Example installation:

```bash
sudo apt update
sudo apt install nginx -y
```

---

# Step-2: Customize Web Page

Edit the web page:

```
/var/www/html/index.html
```

Example content:

```html
<h1>Welcome to Day-26 Lab</h1>
<p>Application deployed using AWS ALB and Route53</p>
```

---

# Step-3: Create Target Group

Navigate to:

```
EC2 → Target Groups → Create Target Group
```

Configuration:

| Setting     | Value    |
| ----------- | -------- |
| Target Type | Instance |
| Protocol    | HTTP     |
| Port        | 80       |

Register the EC2 instance.

---

# Step-4: Create Hosted Zone

Navigate to:

```
Route53 → Hosted Zones
```

Create hosted zone for your domain.

Example:

```
example.com
```

---

# Step-5: Create Public Certificate

Navigate to:

```
AWS Certificate Manager
```

Request a **public certificate** for your domain.

Example:

```
www.example.com
```

Validation method:

```
DNS Validation
```

---

# Step-6: Create CNAME Record

ACM will generate a **CNAME record**.

Add this record inside the hosted zone to validate the certificate.

---

# Step-7: Create Application Load Balancer

Navigate to:

```
EC2 → Load Balancers → Create ALB
```

Configuration:

| Setting   | Value                     |
| --------- | ------------------------- |
| Type      | Application Load Balancer |
| Scheme    | Internet Facing           |
| Listeners | HTTP 80 and HTTPS 443     |

Attach:

* VPC
* Subnets
* Security Groups

---

# Step-8: Configure HTTPS Listener

Attach the **ACM certificate** to the HTTPS listener.

Listener:

```
HTTPS : 443
```

Forward traffic to:

```
Target Group
```

---

# Step-9: Redirect HTTP to HTTPS

Edit the **HTTP : 80 listener**.

Change action to:

```
Redirect → HTTPS 443
```

This forces secure communication.

---

# Step-10: Create Route53 Record

Navigate to:

```
Route53 → Hosted Zone → Create Record
```

Create an **A Record**.

Type:

```
Alias
```

Target:

```
Application Load Balancer DNS
```

Example:

```
www.example.com → ALB DNS
```

---

# Test the Application

Open browser:

```
https://www.example.com
```

Expected output:

```
Custom Web Application Page
```

---
![alt text](<Screenshot (220).png>)