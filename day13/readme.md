# Internship Report – Day 13

**Date:** February 18, 2026  
**Intern Name:** Kiran Gowda  
**Internship Domain:** Cloud 

## 🎯 Objective of the Session
The objective of Day 13 was to gain a detailed understanding of **Azure Policy** for cloud governance and compliance, and to learn the fundamentals of **Docker**, including containerization concepts and commonly used Docker CLI commands.

---

## 🛡️ 1. Azure Policy (Detailed Learning)
Azure Policy is a governance tool in Microsoft Azure used to enforce organizational standards and assess compliance across cloud resources.

### Key Concepts Learned
* Definition of Azure Policy and its importance in cloud governance.
* Policy definitions and initiatives.
* **Scope of policies:** Management Group, Subscription, Resource Group, Resource.
* Policy assignments, compliance evaluation, and reporting.
* Differences between Built-in vs. Custom policies.



### Main Features
* Enforces rules automatically during resource creation.
* Ensures compliance with organizational standards.
* Helps control costs and security risks.
* Supports auditing and remediation.

### Policy Effects
* **Deny:** Prevents non-compliant resources from being created.
* **Audit:** Flags non-compliant resources without blocking them.
* **Append:** Adds additional configuration settings.
* **DeployIfNotExists:** Deploys required configurations automatically.
* **Modify:** Updates resource properties during deployment.

### Practical Understanding
* Creating and assigning policies in the Azure Portal.
* Monitoring compliance status.
* Understanding real-world use cases, such as restricting deployment regions and enforcing resource tagging standards.

---

## 🐳 2. Introduction to Docker
Docker is a containerization platform used to package applications along with their dependencies so they run consistently across different environments.

### Concepts Learned
* **Virtual Machines vs. Containers:** Understanding the architectural differences and efficiency gains of containerization over traditional VMs.
* **Docker Architecture:**
  * Docker Client
  * Docker Daemon
  * Docker Images
  * Docker Containers
  * Docker Hub



### Benefits of Containerization:
* Lightweight deployment
* Faster application startup
* Environment consistency (works the same on a laptop as it does in the cloud)
* Easy scalability



[Image of Virtual Machines vs Containers]


---

## 💻 3. Docker Commands (Hands-on Learning)
Practiced essential Docker CLI commands used daily in real-world DevOps workflows.

### Basic Docker Commands
* `docker --version` : Checks the installed Docker version.
* `docker pull <image_name>` : Downloads an image from Docker Hub.
* `docker images` : Lists all available images downloaded locally.
* `docker run <image_name>` : Creates and starts a container from an image.
* `docker ps` : Shows currently running containers.
* `docker ps -a` : Displays all containers (both running and stopped).
* `docker stop <container_id>` : Gracefully stops a running container.
* `docker start <container_id>` : Starts a stopped container.
* `docker rm <container_id>` : Removes/Deletes a container.
* `docker rmi <image_id>` : Deletes a local Docker image.

### Additional Useful Commands
* `docker exec -it <container_id> bash` : Access the interactive terminal of a running container.
* `docker logs <container_id>` : View the output/logs of a container.
* `docker build -t <image_name> .` : Build a custom Docker image from a Dockerfile in the current directory.

---

## 🚀 Skills Gained & Learning Outcome
* **Cloud Governance:** Understood how to manage compliance and enforce rules across an organization using Azure Policy.
* **Containerization:** Gained foundational knowledge of Docker and how containers simplify application deployment and environment management.
* **CLI Proficiency:** Learned how to run and manage containers through the command-line interface.
* **DevOps Workflows:** Gained insight into modern DevOps deployment practices.

## 📝 Conclusion
Day 13 provided valuable insights into cloud governance and container technology. Azure Policy demonstrated how organizations control and standardize cloud resources to maintain security and manage costs. Meanwhile, Docker introduced modern application deployment practices that are widely used in DevOps and cloud-native environments to ensure reliable, scalable software delivery.