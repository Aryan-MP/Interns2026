
# Day 13 – Azure Policy & Docker Fundamentals

**Date:** February 18, 2026
**Intern Name:** Manoj Gowda
**Internship Domain:** Cloud

---

# 1. Session Objective

The objective of Day 13 was to develop a strong understanding of:

* Azure Policy for cloud governance and compliance
* Docker fundamentals and containerization concepts
* Core Docker CLI commands used in DevOps workflows

The session combined governance concepts with modern container-based deployment practices, strengthening both security and DevOps knowledge.

---

# 2. Azure Policy – Governance & Compliance

## 2.1 Introduction to Azure Policy

Azure Policy is a governance service in Microsoft Azure used to:

* Enforce organizational standards
* Ensure compliance across resources
* Prevent misconfigurations
* Maintain security and cost control

It helps organizations define rules that resources must follow.

Azure Policy is critical in enterprise cloud environments where:

* Multiple teams deploy resources
* Security standards must be maintained
* Cost optimization is required
* Compliance reporting is mandatory

---

## 2.2 Core Concepts of Azure Policy

### Policy Definition

A policy definition defines the rule that will be enforced.

Examples:

* Restrict resource deployment to specific regions
* Require mandatory tags (Environment, Owner, CostCenter)
* Enforce specific VM SKUs
* Block public IP creation

---

### Policy Initiative

An initiative is a collection of multiple policy definitions grouped together.

Used when:

* Multiple compliance rules must be enforced together
* Organizational compliance standards must be applied as a package

---

### Scope of Azure Policy

Policies can be applied at different hierarchical levels:

Management Group
→ Subscription
→ Resource Group
→ Resource

Policies assigned at higher levels apply to all child scopes.

---

### Policy Assignment

Policy assignment connects:

Policy Definition + Scope

Once assigned, Azure continuously evaluates resources for compliance.

---

## 2.3 Policy Effects

Azure Policy supports multiple enforcement behaviors:

### Deny

Prevents non-compliant resource creation.

Example:
If region restriction policy is set to allow only East US, deployment in West US will fail.

---

### Audit

Flags non-compliant resources but does not block them.

Used for monitoring and reporting.

---

### Append

Adds additional configuration settings automatically.

---

### DeployIfNotExists

Automatically deploys required configurations if missing.

Example:
Deploy diagnostic settings automatically.

---

### Modify

Updates resource properties during deployment to ensure compliance.

---

## 2.4 Built-in vs Custom Policies

### Built-in Policies

* Provided by Microsoft
* Cover common governance scenarios
* Easy to assign

### Custom Policies

* Created by organizations
* Used for specific business requirements
* Defined using JSON structure

---

## 2.5 Practical Understanding

Hands-on learning included:

* Creating and assigning policies via Azure Portal
* Monitoring compliance dashboard
* Observing policy evaluation results
* Understanding remediation tasks

Real-world use cases explored:

* Restricting deployment regions
* Enforcing tagging standards
* Blocking certain resource types
* Ensuring cost control measures

---

# 3. Introduction to Docker

## 3.1 What is Docker?

Docker is a containerization platform used to package applications along with:

* Runtime
* Libraries
* Dependencies
* Configuration

Containers ensure applications run consistently across environments.

---

## 3.2 Virtual Machines vs Containers

### Virtual Machines

* Include full operating system
* Heavyweight
* Slower startup
* Higher resource usage

### Containers

* Share host OS kernel
* Lightweight
* Fast startup
* Lower resource consumption
* More scalable

Containers improve deployment efficiency and DevOps workflows.

---

## 3.3 Docker Architecture

Docker consists of:

### Docker Client

User interface to interact with Docker.

### Docker Daemon

Background service managing containers and images.

### Docker Images

Read-only templates used to create containers.

### Docker Containers

Running instances of images.

### Docker Hub

Public registry for storing and sharing images.

---

## 3.4 Benefits of Containerization

* Lightweight deployment
* Faster application startup
* Consistent environment across development and production
* Easy scalability
* Simplified DevOps automation

Containers enable cloud-native application architecture.

---

# 4. Docker CLI Commands – Hands-on Practice

Practical exercises included running and managing containers using CLI.

---

## 4.1 Basic Docker Commands

Check Docker version:

```
docker --version
```

Pull image from Docker Hub:

```
docker pull <image_name>
```

List downloaded images:

```
docker images
```

Run container from image:

```
docker run <image_name>
```

List running containers:

```
docker ps
```

List all containers:

```
docker ps -a
```

Stop container:

```
docker stop <container_id>
```

Start container:

```
docker start <container_id>
```

Remove container:

```
docker rm <container_id>
```

Remove image:

```
docker rmi <image_id>
```

---

## 4.2 Advanced Useful Commands

Access interactive shell inside container:

```
docker exec -it <container_id> bash
```

View container logs:

```
docker logs <container_id>
```

Build custom image from Dockerfile:

```
docker build -t <image_name> .
```

This command builds an image using instructions defined in a Dockerfile.

---

# 5. Skills Gained

## Cloud Governance

* Understanding Azure Policy framework
* Enforcing compliance rules
* Monitoring resource governance
* Evaluating policy effects

## Containerization

* Understanding Docker architecture
* Running containers using CLI
* Differentiating VMs and containers
* Managing images and containers

## DevOps Workflow Understanding

* CLI-based operations
* Container lifecycle management
* Image creation and deployment process
* Real-world container deployment practices

---

# 6. Architectural Insight

Day 13 connected two major areas:

Governance + Application Deployment

Azure Policy ensures:

* Infrastructure is compliant
* Security standards are enforced
* Costs are controlled

Docker enables:

* Modern application packaging
* Environment consistency
* Scalable deployments

Together, they represent core pillars of cloud-native architecture.

---

# 7. Final Outcome

By the end of Day 13, I gained:

* Practical understanding of Azure Policy governance model
* Knowledge of policy definitions, assignments, and compliance evaluation
* Understanding of Docker architecture and containerization
* Hands-on experience with Docker CLI commands
* Insight into modern DevOps deployment practices

---

# 8. Conclusion

Day 13 provided a strong foundation in both:

Cloud Governance (Azure Policy)
and
Container Technology (Docker)

Azure Policy demonstrated how enterprises maintain control, security, and compliance across cloud resources.

Docker introduced modern container-based application deployment, which is essential for cloud-native and DevOps-driven environments.

This session strengthened both infrastructure governance knowledge and application deployment skills.

---
