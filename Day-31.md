#  Day-31 Lab

## Topic: Designing, Developing, and Deploying a Containerized Application using AWS ECS, ECR, EKS, and RDS

---

#  Objective

In this lab we designed, developed, deployed, and operated a **containerized application on AWS** using modern cloud-native services.

The application architecture includes:

* **Docker** for containerization
* **Amazon ECR** for container image storage
* **Amazon ECS (Fargate)** for container orchestration
* **Amazon EKS (Kubernetes)** for container orchestration
* **Amazon RDS** as the managed relational database

The goal is to deploy the same containerized application using **both ECS and EKS** while integrating it with an AWS-managed database.

---

#  Objective

This document explains the theoretical concepts behind **containerization and container orchestration** technologies used in modern cloud applications.

Topics covered:

* Docker fundamentals
* Kubernetes fundamentals
* Why containers exist
* Why orchestration platforms are needed
* Amazon **ECR**, **ECS**, and **EKS**
* Deploying applications in ECS
* Types of EKS clusters

These tools are widely used for **cloud-native application development and deployment**.

---

#  Docker

## What is Docker?

Docker is a **containerization platform** that allows developers to package an application along with its dependencies into a **portable container**.

A container ensures that the application runs the same way in **development, testing, and production environments**.

Example:

```text 
Application
Libraries
Dependencies
Runtime
```

All these components are packaged into a **Docker container**.

---

# Why Docker Exists

Before Docker, applications were deployed directly on servers.

Problems included:

| Problem                 | Description                                    |
| ----------------------- | ---------------------------------------------- |
| Environment Differences | Application works in dev but not in production |
| Dependency Conflicts    | Different apps need different library versions |
| Slow Deployment         | Manual configuration required                  |

Docker solves these issues by **packaging everything inside containers**.

---

# Benefits of Docker

| Benefit         | Description                       |
| --------------- | --------------------------------- |
| Portability     | Run containers anywhere           |
| Isolation       | Applications run independently    |
| Scalability     | Easily create multiple containers |
| Fast Deployment | Containers start quickly          |
| Consistency     | Same environment everywhere       |

---

# Docker Architecture

Docker consists of the following components:

```text 
Docker Client
      │
      ▼
Docker Daemon
      │
      ▼
Docker Images → Docker Containers
```

---

# Docker Images

A **Docker Image** is a read-only template used to create containers.

Example:

```text 
node:18
nginx:latest
mysql:8
```

Images contain:

* Application code
* Dependencies
* Runtime environment

---

# Docker Containers

A **container** is a running instance of a Docker image.

Example:

```bash 
docker run nginx
```

Containers are:

* Lightweight
* Fast to start
* Isolated from the host system

---

# ☸️ Kubernetes

## What is Kubernetes?

Kubernetes (K8s) is a **container orchestration platform** used to manage and scale containerized applications.

It automates:

* Deployment
* Scaling
* Load balancing
* Self-healing
* Service discovery

---

# Why Kubernetes Exists

When applications grow, managing containers manually becomes difficult.

Example problems:

```text 
Hundreds of containers
Multiple servers
Load balancing required
Automatic scaling required
```

Kubernetes solves these problems by **orchestrating containers across clusters**.

---

# Kubernetes Architecture

```text 
Control Plane
   │
   ├── API Server
   ├── Scheduler
   ├── Controller Manager
   │
Worker Nodes
   │
   ├── Pods
   ├── Containers
   └── Kubelet
```

---

# Kubernetes Components

| Component  | Purpose                    |
| ---------- | -------------------------- |
| Pod        | Smallest deployable unit   |
| Node       | Machine running containers |
| Cluster    | Group of nodes             |
| Deployment | Manages pod replicas       |
| Service    | Provides network access    |

---

# Why Use Docker with Kubernetes

Docker provides **container packaging**, while Kubernetes provides **container orchestration**.

Together they enable:

```text 
Build → Package → Deploy → Scale → Manage
```

---

# 📦 Amazon ECR (Elastic Container Registry)

Amazon **ECR** is a fully managed Docker container registry.

It is used to **store and manage Docker images**.

Example workflow:

```text 
Docker Build
     │
     ▼
Push Image → Amazon ECR
     │
     ▼
Pull Image → ECS / EKS
```

---

# Benefits of ECR

| Feature           | Benefit                  |
| ----------------- | ------------------------ |
| Secure Storage    | Integrated with IAM      |
| High Availability | Managed by AWS           |
| Easy Integration  | Works with ECS and EKS   |
| Image Versioning  | Manage multiple versions |

---

# 🚢 Amazon ECS (Elastic Container Service)

Amazon ECS is AWS’s **native container orchestration service**.

It manages Docker containers without requiring Kubernetes.

---

# ECS Components

| Component       | Purpose                           |
| --------------- | --------------------------------- |
| Cluster         | Group of compute resources        |
| Task Definition | Blueprint of container            |
| Task            | Running instance of container     |
| Service         | Maintains desired number of tasks |

---

# ECS Launch Types

| Launch Type | Description                     |
| ----------- | ------------------------------- |
| EC2         | Containers run on EC2 instances |
| Fargate     | Serverless container execution  |

---

# How to Deploy Application in ECS

Typical ECS workflow:

```text 
Build Docker Image
       │
       ▼
Push Image → Amazon ECR
       │
       ▼
Create ECS Cluster
       │
       ▼
Create Task Definition
       │
       ▼
Create ECS Service
       │
       ▼
Application Running
```

---

# Why ECS is Used

| Benefit           | Description                       |
| ----------------- | --------------------------------- |
| Fully Managed     | AWS handles orchestration         |
| Scalable          | Automatically scales containers   |
| Secure            | IAM integration                   |
| Serverless Option | Fargate removes server management |

---

# ☸️ Amazon EKS (Elastic Kubernetes Service)

Amazon EKS is a **managed Kubernetes service**.

It allows running Kubernetes clusters on AWS without managing the control plane.

---

# Benefits of EKS

| Feature            | Benefit                   |
| ------------------ | ------------------------- |
| Managed Kubernetes | AWS manages control plane |
| High Availability  | Multi-AZ deployment       |
| Security           | Integrated with IAM       |
| Scalable           | Supports large workloads  |

---

# Types of EKS Clusters

---

# 1️⃣ Managed Node Group

In managed node groups, AWS automatically manages worker nodes.

Benefits:

* Automatic node provisioning
* Auto scaling
* Simplified management

Example:

```text 
EKS Control Plane
        │
        ▼
Managed Node Group
        │
        ▼
Worker Nodes
```

---

# 2️⃣ Self-Managed Node Group

Users manually manage EC2 worker nodes.

Responsibilities include:

* Node configuration
* Scaling
* Maintenance

Example:

```text 
User Managed EC2 Nodes
```

---

# 3️⃣ AWS Fargate for EKS

In this model, containers run **without managing servers**.

Advantages:

* No node management
* Serverless container execution
* Automatic scaling

---

# ECS vs EKS

| Feature       | ECS           | EKS                  |
| ------------- | ------------- | -------------------- |
| Orchestration | AWS Native    | Kubernetes           |
| Complexity    | Simple        | More complex         |
| Flexibility   | Limited       | Highly flexible      |
| Use Case      | AWS workloads | Kubernetes ecosystem |

---

# When to Use ECS

Use ECS when:

* Applications are Docker-based
* Kubernetes features are not required
* Simpler container orchestration is preferred

---

# When to Use EKS

Use EKS when:

* Kubernetes ecosystem is required
* Multi-cloud portability is needed
* Advanced orchestration features are required

---

#  AWS Services Used

| Service    | Purpose                            |
| ---------- | ---------------------------------- |
| Amazon ECR | Container image repository         |
| Amazon ECS | Container orchestration            |
| Amazon EKS | Kubernetes container orchestration |
| Amazon RDS | Managed relational database        |
| Docker     | Containerization platform          |
| EC2        | Used for EKS management tools      |
| IAM        | Secure service access              |

---

#  Architecture Overview

```text 
           User
             │
             ▼
        Load Balancer
             │
     ┌───────┴────────┐
     ▼                ▼
   ECS Service       EKS Cluster
       │                 │
       ▼                 ▼
   Docker Container   Docker Container
            │
            ▼
        Amazon RDS
```

The containerized application communicates with **Amazon RDS database** for storing customer data.

---

#  Task-1: Application Setup and ECR

---

# Step-1: Create Amazon RDS Database

Navigate to:

```text 
AWS Console → RDS → Create Database
```

Configuration example:

| Setting  | Value    |
| -------- | -------- |
| Engine   | MySQL    |
| DB Name  | crm_db   |
| Username | admin    |
| Password | admin123 |

---

# Step-2: Create Database Schema

Connect to the RDS database and execute the following SQL.

```sql 
-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS crm_db;
USE crm_db;

-- Step 2: Create the customers table
CREATE TABLE IF NOT EXISTS customers (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100)  NOT NULL,
  email       VARCHAR(150)  NOT NULL UNIQUE,
  phone       VARCHAR(25),
  company     VARCHAR(120),
  status      ENUM('Lead', 'Active', 'Inactive') DEFAULT 'Lead',
  deal_value  DECIMAL(14,2) DEFAULT 0.00,
  source      VARCHAR(60),
  notes       TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

# Step-3: Build Docker Image from Application Code

Clone the application repository from GitHub.

```bash 
git clone https://github.com/charankumar2104/task-app.git
cd task-app
```

Build Docker image.

```bash 
docker build -t test:1.0 .
```

---

# Step-4: Run Docker Container Locally

Run the container using the following command.

```bash id="dsk3ng"
sudo docker run -d \
  -p 80:3000 \
  -e PORT=3000 \
  -e <RDS-Endpoint> \
  -e DB_PORT=3306 \
  -e DB_USER=<RDS-username> \
  -e DB_PASSWORD=<RDS-Password> \
  -e DB_NAME=crm_db \
  --name crm-app \
  <Image:tag>
```

Now the application can be accessed using:

```text 
http://<EC2-PUBLIC-IP>
```

---

# Step-5: Create Amazon ECR Repository

Navigate to:

```text 
AWS Console → ECR → Create Repository
```

Example repository name:

```text 
crm-app-repo
```

---

# Step-6: Push Docker Image to ECR

Authenticate Docker with ECR.

```bash 
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

Tag the image.

```bash 
docker tag test:1.0 <account-id>.dkr.ecr.us-east-1.amazonaws.com/crm-app-repo:1.0
```

Push the image.

```bash 
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/crm-app-repo:1.0
```

---

#  Task-2: Deploy Application using ECS

---

# Step-1: Create ECS Cluster

Navigate to:

```text 
AWS Console → ECS → Create Cluster
```

Select:

```text 
Fargate
```

---

# Step-2: Create Task Definition

Navigate to:

```text 
ECS → Task Definitions → Create
```

Configuration:

| Setting         | Value         |
| --------------- | ------------- |
| Launch Type     | AWS Fargate   |
| Container Image | ECR Image URI |
| Container Port  | 3000          |

---

# Step-3: Add Environment Variables

Add the following variables inside container configuration.

| Variable    | Value            |
| ----------- | ---------------- |
| PORT        | 3000             |
| DB_HOST     | `<RDS-endpoint>` |
| DB_PORT     | 3306             |
| DB_USER     | `<RDS-username>` |
| DB_PASSWORD | `<RDS-password>` |
| DB_NAME     | crm_db           |

---

# Step-4: Create ECS Service

Navigate to:

```text 
Cluster → Create Service
```

Configuration:

| Setting         | Value        |
| --------------- | ------------ |
| Launch Type     | Fargate      |
| Task Definition | Created task |
| Public IP       | Enabled      |

Ensure the service uses the **same VPC and subnet as RDS**.

---

# Step-5: Access the Application

Access using service endpoint.

Example:

```text 
http://<ECS-Public-IP>:<Port>
```

---

#  Task-3: Deploy Same Application using EKS

---

# Step-1: Create EC2 Instance for Cluster Management

Install required tools:

```bash 
sudo yum install aws-cli -y
```

Install kubectl.

```bash 
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
```

Install eksctl.

```bash 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

---

# Step-2: Create EKS Cluster

```bash 
eksctl create cluster --name <cluster-name> --region <region-name> --node-type <instance-type> --nodes <desired-node-count>

```

Cluster creation may take **10–15 minutes**.

---

# Step-3: Create Kubernetes Deployment

Create file:

```text 
deployment.yaml
```

Add deployment configuration.

```yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crm-app
  labels:
    app: crm-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crm-app
  template:
    metadata:
      labels:
        app: crm-app
    spec:
      containers:
        - name: crm-app
          image: test:1.0
          ports:
            - containerPort: 3000
          env:
            - name: PORT
              value: "3000"
            - name: DB_HOST
              value: "database-1.cydccqm041wu.us-east-1.rds.amazonaws.com"
            - name: DB_PORT
              value: "3306"
            - name: DB_USER
              value: "admin"
            - name: DB_PASSWORD
              value: "admin123"
            - name: DB_NAME
              value: "crm_db"
          resources:
            requests:
              cpu: "250m"
              memory: "256Mi"
            limits:
              cpu: "500m"
              memory: "512Mi"
          livenessProbe:
            httpGet:
              path: /api/health
              port: 3000
            initialDelaySeconds: 15
            periodSeconds: 30
          readinessProbe:
            httpGet:
              path: /api/health
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 10
```

---

# Step-4: Create Kubernetes Service

Create file:

```text 
service.yaml
```

Add service configuration.

```yaml 
apiVersion: v1
kind: Service
metadata:
  name: crm-app-service
  labels:
    app: crm-app
spec:
  selector:
    app: crm-app
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

---

# Step-5: Deploy Application

Apply deployment.

```bash 
kubectl apply -f deployment.yaml
```

Apply service.

```bash 
kubectl apply -f service.yaml
```

---

# Step-6: Verify Deployment

Check pods.

```bash 
kubectl get pods
```

Check services.

```bash 
kubectl get svc
```

---

# Step-7: Access Application

Once the service is created, Kubernetes provides a **Load Balancer endpoint**.

Example:

```text 
http://<load-balancer-endpoint>
```

---

# 🧪 Task-4: Database Integration with Application

The application connects to **Amazon RDS MySQL database**.

Connection parameters:

| Parameter   | Value        |
| ----------- | ------------ |
| DB_HOST     | RDS endpoint |
| DB_PORT     | 3306         |
| DB_USER     | admin        |
| DB_PASSWORD | admin123     |
| DB_NAME     | crm_db       |

The application stores customer data inside the **customers table** created earlier.

---
![S](<Screenshot (252).png>)