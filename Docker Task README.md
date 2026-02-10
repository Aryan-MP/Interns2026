<h1> 🚀 Push Docker Image to Azure Container Registry (ACR) from Linux </h1>

This project demonstrates how to build a Docker image, tag it, and push it to Azure Container Registry (ACR) from a Linux machine, and then verify it in Azure.

<h2>📌 Problem Statement</h2>

<ul>We want to:
<li> Create a Docker image locally </li>
<li>Push the image to Azure Container Registry (ACR)</li>
<li>Store images securely in a private registry</li>
<li>Make the image available for VMs, AKS, or CI/CD pipelines</li> </ul>



<h2> 🧠 What is Azure Container Registry (ACR)? </h2>

ACR is a private Docker registry service in Azure used to store and manage container images.

Key Benefits
<ul> <li> Secure (Azure AD integration)</li>
<li>Private registry</li>
<li>High performance</li>
<li>Native integration with AKS & Azure DevOps </li></ul>


<h2>🧩 Prerequisites</h2>
<ul><li>Azure Subscription</li>
<li>Linux machine (Ubuntu preferred)</li>
<li>Docker installed</li>
<li>Azure CLI installed</li>
<li>Existing Docker image</li></ul>

<h2>🛠 Tools Used</h2>
<ul><li>Docker</li>
<li>Azure CLI</li>
<li>Azure Container Registry (ACR)</li></ul>

<h2>🏗 Architecture Flow</h2>
Dockerfile
   ↓
Docker Image (Local)
   ↓
Tag Image
   ↓
Push to ACR
   ↓

Stored in Azure Container Registry


