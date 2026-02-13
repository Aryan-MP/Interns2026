 ARM Template Deployment – Multi OS (Windows + Linux)
 Project Overview

This project demonstrates Infrastructure as Code (IaC) using a single ARM Template in Azure.

Using one ARM template (template.json),(parameter.json) I deployed:

 Windows Server 2022 VM with IIS installed

 Ubuntu 22.04 VM with Nginx installed

 One Virtual Network (VNet)

 Two Network Interfaces (NICs)

 Two Public IP Addresses (Standard SKU)

 Custom index.html for both VMs

Both virtual machines were deployed successfully and accessed using their Public IP addresses.



Task 2 – Monitoring ARM Deployment
 Monitor Deployment in Azure Portal
Second task deploy ARM templete using Custom deployment

ARM template (storage(1).json)
Task 2 – Monitoring ARM Deployment
 Monitor Deployment in Azure Portal

1️⃣ Go to Azure Portal
2️⃣ Navigate to Resource Groups
3️⃣ Select your Resource Group
4️⃣ Click Deployments

You can see:

Deployment Name

Status (Running / Succeeded / Failed)

Start & End Time

Error Details (if failed)

📘 Task 3 – Learn ARM Template Structure

I studied the official ARM Template documentation and understood how to create templates from scratch.

ARM Template Structure

An ARM template contains:

1️⃣ $schema

Defines the template format reference.

2️⃣ contentVersion

Used to track template version.

3️⃣ parameters

Input values provided during deployment.

4️⃣ variables

Reusable values inside template.

5️⃣ resources

Defines the Azure resources to create (VM, VNet, Storage, etc.).

6️⃣ outputs

Displays values after deployment (like Public IP).