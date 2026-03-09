# Day-25 Lab

## Topic: EC2 IAM Roles, S3 Integration, User Data Automation & CloudWatch Logging

---

# Objective

In this lab we worked on integrating **EC2 with S3 and CloudWatch using IAM Roles**.

The lab focuses on:

* Creating **S3 buckets**
* Granting **EC2 permissions to access S3**
* Using **User Data scripts for automation**
* Storing **Docker installation scripts in S3**
* Sending **application logs to CloudWatch**

These are common practices used in **automated cloud infrastructure and DevOps environments**.

---

#  AWS Services Used

| Service    | Purpose                             |
| ---------- | ----------------------------------- |
| EC2        | Virtual machine to run applications |
| S3         | Store scripts and objects           |
| IAM        | Manage roles and permissions        |
| CloudWatch | Store and monitor application logs  |
| User Data  | Automate instance configuration     |

---

#  Task-1: EC2 Accessing S3 Bucket Using IAM Role

---

# Architecture Overview

```
EC2 Instance
     │
     │ IAM Role
     ▼
S3 Bucket
```

EC2 will upload objects to S3 using an **IAM role instead of access keys**.

---

# Step-1: Create an S3 Bucket

Navigate to:

```
AWS Console → S3 → Create Bucket
```

Example bucket name:

```
day25-ec2-s3-bucket
```

---

# Step-2: Create IAM Policy for S3 Access

Create a policy that allows EC2 to **put objects into the S3 bucket**.

Add policy JSON below.

```json 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:CreateBucket",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
}
```

---

# Step-3: Create IAM Role for EC2

Navigate to:

```
IAM → Roles → Create Role
```

Choose trusted entity:

```
EC2
```

Attach the policy created in **Step-2**.

Example role name:

```
EC2S3UploadRole
```

---

# Step-4: Launch EC2 Instance

While launching the instance:

Attach the role:

```
EC2S3UploadRole
```

---

# Step-5: Install Nginx Using User Data

User Data allows automation during instance startup.

Add the following script.

```bash 
#!/bin/bash

sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Day-25 Lab Nginx Setup Complete" > /var/www/html/index.html
```

This script will:

* Install nginx
* Start nginx
* Enable nginx service
* Update homepage

---

# Step-6: Upload Object to S3

Login to EC2 and test S3 upload.

```bash 
echo "Hello from EC2" > testfile.txt
aws s3 cp testfile.txt s3://day25-ec2-s3-bucket/
```

Verify object inside the S3 bucket.

---

# Task-2: Docker Setup Using S3 Script and CloudWatch Logging

---

# Architecture Overview

```
        EC2 Instance
           │
           │ IAM Role
           │
     ┌─────┴─────────┐
     │               │
     ▼               ▼
   S3 Bucket     CloudWatch Logs
(Docker Script)   (Application Logs)
```

---

# Step-1: Create S3 Bucket for Docker Script

Navigate to:

```
AWS Console → S3 → Create Bucket
```

Example bucket:

```
day25-docker-scripts
```

---

# Step-2: Create Docker Installation Script

Create file:

```id="bxtp2g"
docker-install.sh
```

Example script:

```bash 
#!/bin/bash

yum update
yum install docker -y
systemctl start docker.service
docker pull cherry2104/java-proj:web

docker run -d \
  --name my-container \
  --log-driver awslogs \
  --log-opt awslogs-region=us-east-1 \
  --log-opt awslogs-group=/docker/my-container \
  --log-opt awslogs-create-group=true \
  -p 80:80 \
  cherry2104/java-proj:web  

```

Upload this file to the S3 bucket.

---

# Step-3: Create IAM Policy for EC2 Role

The policy should allow:

* Access to S3 bucket
* Access to CloudWatch logs

Add policy JSON below.

```json 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "s3:ListAllMyBuckets",
                "logs:DescribeLogStreams",
                "s3:CreateBucket",
                "s3:ListBucket",
                "logs:PutRetentionPolicy",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```

---

# Step-4: Create IAM Role for EC2

Navigate to:

```
IAM → Roles → Create Role
```

Trusted entity:

```
EC2
```

Attach the policy created in **Step-3**.

Example role name:

```
EC2DockerCloudWatchRole
```

---

# Step-5: Launch EC2 Instance

Attach role:

```
EC2DockerCloudWatchRole
```

---

# Step-6: Execute Docker Script from S3

Connect to EC2 and download the script.

```bash id="s1p3sw"
aws s3 cp s3://day25-docker-scripts/docker-install.sh .
```

Run the script.

```bash id="92tbcb"
chmod +x docker-install.sh
./docker-install.sh
```

---

Logs will be sent to **CloudWatch Log Groups**.

---

# Verify Logs in CloudWatch

Navigate to:

```
CloudWatch → Logs → Log Groups
```

Check logs generated from EC2.

---