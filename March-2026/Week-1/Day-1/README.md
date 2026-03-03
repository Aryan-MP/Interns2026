```markdown

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

```

Client Application
↓
Azure OpenAI Endpoint
↓
Model Deployment (GPT-4.1 Mini)
↓
Generated Response

````id="aiarch1"

---

# 6. Azure CLI Commands Used

## 6.1 List Cognitive Services Accounts

```bash
az cognitiveservices account list \
  --resource-group manoj-rg \
  -o table
````

Purpose:

* Verify AI service resource
* Confirm region
* Confirm deployment existence

Output example:

| Kind       | Location | Name              | ResourceGroup |
| ---------- | -------- | ----------------- | ------------- |
| AIServices | eastus   | AIModelDeployment | manoj-rg      |

---

## 6.2 Fetch Endpoint

```bash
az cognitiveservices account show \
  --name AIModelDeployment \
  --resource-group manoj-rg \
  --query "properties.endpoint"
```

This returns:

```
https://<resource-name>.openai.azure.com/
```

This endpoint is required for API calls.

---

## 6.3 Fetch API Key

```bash
az cognitiveservices account keys list \
  --name AIModelDeployment \
  --resource-group manoj-rg
```

This returns:

* key1
* key2

Used for:

* Authentication
* Secure API access

---

# 7. Understanding API Endpoint Structure

Azure OpenAI endpoint format:

```
https://<resource-name>.openai.azure.com/openai/deployments/<deployment-name>/chat/completions?api-version=2024-xx-xx
```

Components explained:

| Part            | Meaning               |
| --------------- | --------------------- |
| resource-name   | Azure AI service name |
| deployments     | Deployment container  |
| deployment-name | Your model deployment |
| api-version     | Required API version  |

Authentication header:

```
api-key: <your-key>
```

---

# 8. What is TPM (Tokens Per Minute)?

TPM defines:

* Maximum tokens processed per minute
* Controls throughput
* Impacts performance scaling
* Affects pricing

You configured:

10,000 TPM

This allows moderate enterprise workload capacity.

---

# 9. Enterprise Use Case

Azure OpenAI is used for:

* Chatbots
* Customer support automation
* Document summarization
* Code generation
* Internal knowledge assistants
* AI-powered dashboards

Because it runs inside Azure:

* RBAC can control access
* Networking rules can restrict access
* Private endpoints can be configured
* Data remains within Azure region

---

# 10. Security Considerations

Best practices include:

* Store API keys in Azure Key Vault
* Restrict access via RBAC
* Use Managed Identity instead of raw keys
* Limit public network access
* Monitor usage metrics

Never hardcode API keys inside source code.

---

# 11. Technical Inference

Logical reasoning used:

If AI model is deployed inside Azure AI Services
And API endpoint is required for interaction
Therefore model access must happen via HTTPS REST API.

(Logical Form: Modus Ponens)

* If service exposes endpoint → it is API-driven
* Azure OpenAI exposes endpoint
* Therefore Azure OpenAI is API-driven

---

# 12. Key Concepts Learned

* Azure AI Services deployment
* Model deployment lifecycle
* GPT-4.1 Mini configuration
* Tokens per minute (TPM)
* Endpoint extraction using CLI
* API key retrieval
* Azure CLI cognitive services commands
* Enterprise AI architecture basics

---

# 13. Final Outcome

By the end of Day 1 (March Week-1):

* Successfully deployed Azure AI Services.
* Deployed GPT-4.1 Mini with 10k TPM.
* Extracted endpoint using Azure CLI.
* Retrieved API keys securely.
* Understood deployment-level model configuration.
* Understood API interaction structure.

---

# 14. Conclusion

This session introduced Azure OpenAI deployment and API-based model interaction inside Azure.

It strengthened understanding of:

* AI model provisioning
* Azure CLI usage
* Endpoint-based communication
* Secure API authentication
* Enterprise AI service architecture

This marks the beginning of AI model integration within cloud engineering workflows.

```
