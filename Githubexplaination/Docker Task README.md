🚀 Push Docker Image to Azure Container Registry (ACR) from Linux

This project demonstrates how to build a Docker image, tag it, and push it to Azure Container Registry (ACR) from a Linux machine, and then verify it in Azure.

📌 Problem Statement

We want to:
Create a Docker image locally
Push the image to Azure Container Registry (ACR)
Store images securely in a private registry
Make the image available for VMs, AKS, or CI/CD pipelines


🧠 What is Azure Container Registry (ACR)?
ACR is a private Docker registry service in Azure used to store and manage container images.

Key Benefits
Secure (Azure AD integration)
Private registry
High performance
Native integration with AKS & Azure DevOps

🧩 Prerequisites
Azure Subscription
Linux machine (Ubuntu preferred)
Docker installed
Azure CLI installed
Existing Docker image

🛠 Tools Used
Docker
Azure CLI
Azure Container Registry (ACR)

🏗 Architecture Flow
Dockerfile
   ↓
Docker Image (Local)
   ↓
Tag Image
   ↓
Push to ACR
   ↓
Stored in Azure Container Registry