Task 01: VM Creation using ARM Template, IIS Installation & Static Website Hosting
Description

In this task, I deployed a Virtual Machine using an Azure Resource Manager (ARM) template. After successful deployment, I installed IIS (Internet Information Services) and Google Chrome on the VM. Then, I hosted a customized static website using HTML.

Steps Performed
1️⃣ VM Deployment using ARM Template

Created an ARM template (azuredeploy.json)

Defined resources:

Virtual Machine

Network Interface

Virtual Network

Public IP

Deployed the VM using:

<img width="1920" height="1032" alt="Screenshot 2026-02-11 165539" src="https://github.com/user-attachments/assets/889f5c37-74c9-4587-a264-a61dc10eb3e5" />

Azure Portal / Azure CLI

Verified successful VM provisioning

2️⃣ IIS Installation

Connected to the VM using Remote Desktop (RDP)

Installed IIS Web Server

Verified IIS default page through Public IP

3️⃣ Chrome Installation

Installed Google Chrome for browser-based validation

<img width="1920" height="1080" alt="Screenshot (145)" src="https://github.com/user-attachments/assets/31adbf2a-82f3-427b-820e-51a077b3ffaf" />

4️⃣ Static Website Hosting


Created a custom HTML <img width="1920" height="1032" alt="Screenshot 2026-02-11 161042" src="https://github.com/user-attachments/assets/314d0026-6a20-4a20-a675-b859ca9a1df4" />
file

Replaced default IIS page (C:\inetpub\wwwroot)

Hosted customized static website

Accessed website using VM Public IP

Outcome

VM successfully deployed using Infrastructure as Code (ARM Template)

IIS web server configured

Static website hosted and publicly accessible

Practical experience with ARM-based deployment

Task 02: Storage Account Creation, Disk Management & VM Disk Attachment
Description

In this task, I created an Azure Storage Account and additional managed disks. The disk was then attached to the existing Virtual Machine and configured for use.

Steps Performed
1️⃣ Storage Account Creation

Created a Storage Account

<img width="1920" height="1080" alt="Screenshot (146)" src="https://github.com/user-attachments/assets/6556dc9f-33fe-488e-8128-72eabbfe8dde" />

Selected:

Performance type (Standard/Premium)

Replication type (LRS/ZRS)

Verified successful deployment

2️⃣ Managed Disk Creation

Created a new Managed Disk

Selected size and performance tier

3️⃣ Disk Attachment to VM
<img width="1920" height="1032" alt="Screenshot 2026-02-11 165508" src="https://github.com/user-attachments/assets/eae33c35-b5fd-41a6-9c85-e0d84e232e0e" />


Attached the created disk to the VM

Logged into VM

Initialized and formatted the disk

Assigned drive letter (Windows)

Verified disk availability

Outcome

Successfully created Storage Account

Managed disk attached and configured

Expanded VM storage capacity

Task 03: Azure Container Registry (ACR) and Azure Container Instances (ACI)
Description

In this task, I created an Azure Container Registry (ACR) to store Docker images and deployed containerized applications using Azure Container Instances (ACI).

Steps Performed
1️⃣ Azure Container Registry (ACR)

Created ACR resource

Enabled Admin User (if required)

Logged in using Azure CLI

Verified registry access

2️⃣ Container Image Push

Tagged Docker image with ACR login server name

Pushed image to ACR

3️⃣ Azure Container Instance (ACI)

Created Azure Container Instance
<img width="1920" height="1080" alt="Screenshot (148)" src="https://github.com/user-attachments/assets/1b49488f-d268-494c-85bd-9b55bbf5cde8" />

Selected image from ACR

Configured CPU and Memory

Assigned Public IP

<img width="1920" height="1080" alt="Screenshot (147)" src="https://github.com/user-attachments/assets/a0916496-c2fd-43df-a378-9b11374eb90e" />

Deployed container

Outcome

Container image stored securely in ACR

Container instance deployed successfully

Application accessible via public endpoint
