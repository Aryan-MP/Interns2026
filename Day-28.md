# 📘 Day-28 Lab

## Topic: Static Website Hosting using Amazon S3 and Accessing via CloudFront CDN

---

# 🎯 Objective

In this lab we explored **Amazon S3 and AWS CloudFront** and implemented a static website hosting architecture.

The lab includes:

* Understanding **Amazon S3 basics**
* Understanding **AWS CloudFront basics**
* Hosting a **static website using S3**
* Delivering the website using **CloudFront CDN**
* Accessing website content through **CloudFront DNS endpoint**

This architecture improves **performance, availability, and global delivery of web content**.

---

# ☁️ Amazon S3 (Simple Storage Service)

Amazon **S3** is an object storage service designed to store and retrieve any amount of data.

It provides:

* High durability (99.999999999%)
* High availability
* Scalability
* Secure storage

Common use cases:

| Use Case               | Description                  |
| ---------------------- | ---------------------------- |
| Static Website Hosting | Hosting HTML/CSS/JS websites |
| Backup & Archival      | Store backups                |
| Data Lakes             | Big data storage             |
| Media Storage          | Images, videos, files        |
| Application Assets     | Store application content    |

---

# S3 Core Components

---

## Bucket

A **Bucket** is a container used to store objects.

Example:

```id="mt8y87"
my-static-website-bucket
```

Characteristics:

* Globally unique name
* Region specific
* Stores objects

---

## Objects

Objects are files stored inside buckets.

Examples:

```id="d7a4dt"
index.html
style.css
script.js
image.png
```

Each object contains:

* Data
* Metadata
* Unique key

---

## Static Website Hosting

Amazon S3 allows hosting static websites directly.

Supported content:

* HTML
* CSS
* JavaScript
* Images

Example files:

```id="p85d96"
index.html
error.html
```

When enabled, S3 generates a **website endpoint**.

Example:

```id="3l4d7v"
http://bucket-name.s3-website-region.amazonaws.com
```

---

# 🌐 AWS CloudFront

**AWS CloudFront** is a global Content Delivery Network (CDN).

It distributes content from AWS services to users through **edge locations**.

Benefits:

* Faster content delivery
* Reduced latency
* Secure HTTPS connections
* Global content distribution
* DDoS protection

---

# How CloudFront Works

```id="c7yff3"
User Request
      │
      ▼
CloudFront Edge Location
      │
      ▼
Origin Server (S3 Bucket)
```

Flow:

1. User sends request to CloudFront.
2. CloudFront checks cache at nearest edge location.
3. If content exists → served directly.
4. If not → fetched from S3 origin.
5. Content cached and delivered to user.

---

# Advantages of Using CloudFront with S3

| Feature        | Benefit                 |
| -------------- | ----------------------- |
| Global CDN     | Faster website loading  |
| Caching        | Reduces S3 load         |
| HTTPS          | Secure content delivery |
| Edge Locations | Low latency             |
| Scalability    | Handles large traffic   |

---

# 🧪 Task-1: Host Static Website using S3 and Access via CloudFront

---

# Architecture Overview

```id="w9kqja"
User Browser
      │
      ▼
CloudFront Distribution
      │
      ▼
S3 Bucket (Static Website)
```

CloudFront acts as a **global delivery layer for the S3 hosted website**.

---

# Step-1: Create an S3 Bucket

Navigate to:

```id="q1x6lt"
AWS Console → S3 → Create Bucket
```

Example bucket name:

```id="wn5ey4"
day28-static-site
```

Important configuration:

* Disable **Block Public Access**
* Enable **Static Website Hosting**

---

# Step-2: Upload Website Files

Upload files such as:

```id="ttq9m5"
index.html
style.css
images/
```

Example `index.html`:

```html id="9a3s1m"
<h1>Welcome to Day-28 Static Website</h1>
<p>This website is hosted using Amazon S3 and delivered via CloudFront.</p>
```

---

# Step-3: Enable Static Website Hosting

Navigate to:

```id="f1rfy0"
Bucket → Properties → Static Website Hosting
```

Configuration:

| Setting        | Value      |
| -------------- | ---------- |
| Index Document | index.html |
| Error Document | error.html |

After enabling, S3 generates a **website endpoint URL**.

Example:

```id="4h7fr2"
http://day28-static-site.s3-website-us-east-1.amazonaws.com
```

---

# Step-4: Configure Bucket Policy

Allow public access to objects.

Example policy:

```json id="flrl3o"
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": "*",
     "Action": "s3:GetObject",
     "Resource": "arn:aws:s3:::day28-static-site/*"
   }
 ]
}
```

---

# Step-5: Create CloudFront Distribution

Navigate to:

```id="xrl16f"
AWS Console → CloudFront → Create Distribution
```

Configuration:

| Setting                | Value                  |
| ---------------------- | ---------------------- |
| Origin                 | S3 Bucket              |
| Viewer Protocol Policy | Redirect HTTP to HTTPS |
| Cache Policy           | Default                |

CloudFront generates a **distribution domain name**.

Example:

```id="35rtzo"
d123abcd.cloudfront.net
```

---

# Step-6: Wait for Distribution Deployment

CloudFront takes around **5–10 minutes** to deploy globally.

Once deployed, the distribution status becomes **Enabled**.

---

# Step-7: Access Website via CloudFront

Open browser:

```id="h2kbbq"
https://d123abcd.cloudfront.net
```

Now the website is delivered using **CloudFront CDN instead of direct S3 access**.

---

# Content Delivery Flow

```id="7dqkm4"
User Request
      │
      ▼
Nearest CloudFront Edge Location
      │
      ▼
Cached Content
      │
      ▼
S3 Bucket (Origin)
```

CloudFront caches content to improve performance.

---
![alt text](<Screenshot (236).png>) ![alt text](<Screenshot (235).png>) ![alt text](<Screenshot (234).png>) ![alt text](<Screenshot (233).png>)