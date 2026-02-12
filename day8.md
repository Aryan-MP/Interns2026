Task 01: VM Creation using ARM Template, IIS Installation & Static Website Hosting
Description
In this task, I deployed a Virtual Machine using an Azure Resource Manager (ARM) template. After successful deployment, I installed IIS (Internet Information Services) and Google Chrome on the VM. Then, I hosted a customized static website using HTML.
            Steps Performed
                      1.VM Deployment using ARM Template

                        Created an ARM template (azuredeploy.json)
                        Defined resource
                        Virtual Machine
                        Network Interface
                        Virtual Network
                        Public IP
                        Deployed the VM using
                        Azure Portal / Azure CLI
                    2. IIS Installation
                    3️.Chrome Installation
                    4️.Static Website Hosting
                                     Accessed website using VM Public IP
<img width="1900" height="1054" alt="Screenshot 2026-02-11 164907" src="https://github.com/user-attachments/assets/e276a7c8-a78f-4b0f-ac37-2142881755d3" />


Task 02: Storage Account Creation, Disk Management & VM Disk Attachment
Description

In this task, I created an Azure Storage Account and additional managed disks. The disk was then attached to the existing Virtual Machine and configured for use.

Steps Performed
1️.Storage Account Creation

Created a Storage Account
Selected:

Performance type (Standard/Premium)

Replication type (LRS/ZRS)

Verified successful deployment

2️. Managed Disk Creation

Created a new Managed Disk

Selected size and performance tier

3️. Disk Attachment to VM

Attached the created disk to the VM

Logged into VM

Initialized and formatted the disk

Assigned drive letter (Windows)

Verified disk availability


<img width="1906" height="957" alt="Screenshot 2026-02-11 165951" src="https://github.com/user-attachments/assets/358ed419-ba59-43ad-8ece-a20c7dc52520" />


Task 03: Azure Container Registry (ACR) and Azure Container Instances (ACI)
Description

In this task, I created an Azure Container Registry (ACR) to store Docker images and deployed containerized applications using Azure Container Instances (ACI).

Steps Performed
1️.Azure Container Registry (ACR)

Created ACR resource

Enabled Admin User (if required)

Logged in using Azure CLI

Verified registry access

2️.Container Image Push

Tagged Docker image with ACR login server name

Pushed image to ACR

3️.Azure Container Instance (ACI)

Created Azure Container Instance

Selected image from ACR

Configured CPU and Memory

Assigned Public IP

Deployed container
<img width="1909" height="965" alt="Screenshot 2026-02-11 174152" src="https://github.com/user-attachments/assets/cdd325cc-ff7b-4b2c-b6f7-1b9913a19547" />


