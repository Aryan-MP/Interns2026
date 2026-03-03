
# Day 1 – Azure OpenAI (Azure AI Services) Model Deployment & Endpoint Management

**Date:** March 2, 2026  
**Intern Name:** Manoj Gowda  
**Role:** Cloud Engineer Trainee Intern  
**Organization:** Spektra Systems  

---

# 1. Objective

The objective of this session was to deploy and manage an Azure OpenAI model using Azure AI Services.

The focus areas were:

- Deploying Azure AI Services
- Deploying GPT-4.1 Mini model
- Understanding model deployment configuration
- Extracting endpoint and API keys using Azure CLI
- Listing Cognitive Services accounts
- Understanding how API endpoints work

This session introduced AI service deployment in Azure using Infrastructure as Code and CLI tools.

---

# 2. What is Azure OpenAI?

Azure OpenAI is a Microsoft Azure service that provides access to OpenAI models such as:

- GPT models (text generation)
- Embedding models
- Image generation models
- Chat completion models

It is built on top of:

- Azure Resource Manager
- Azure Cognitive Services infrastructure
- Secure API-based access

It allows enterprises to use advanced AI models inside a secure Azure environment.

---

# 3. What Was Deployed

You deployed:

| Component | Value |
|------------|--------|
| Resource Type | Azure AI Services |
| Resource Name | AIModelDeployment |
| Region | East US |
| Model | GPT-4.1 Mini |
| TPM (Tokens per minute) | 10,000 |
| Access Type | API Key |
| Deployment Method | ARM + Azure CLI |

---

# 4. Understanding Model Deployment in Azure OpenAI

Deploying Azure OpenAI involves two levels:

## 4.1 Azure AI Services Resource

This is the main container resource.

It provides:

- Endpoint URL
- API keys
- Authentication
- Billing
- Region binding

Think of it like a "gateway" to AI models.

---

## 4.2 Model Deployment

After creating the AI resource:

You deploy a specific model inside it.

Example:

- Model name: gpt-4.1-mini
- Deployment name: AIModelDeployment
- Throughput: 10k TPM

Deployment name is important because:

API calls reference the deployment name, not just the model name.

---

# 5. Architecture Flow
