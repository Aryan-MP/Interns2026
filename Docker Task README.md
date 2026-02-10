<h1> 🚀 Push Docker Image to Azure Container Registry (ACR) from Linux </h1>

This project demonstrates how to build a Docker image, tag it, and push it to Azure Container Registry (ACR) from a Linux machine, and then verify it in Azure.

<h2>📌 Problem Statement</h2>

<ul>We want to:
<li> Create a Docker image locally </li>
<li>Push the image to Azure Container Registry (ACR)</li>
<li>Store images securely in a private registry</li>
<li>Make the image available for VMs, AKS, or CI/CD pipelines</li> </ul>



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

