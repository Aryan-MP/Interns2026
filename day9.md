Task : Parameterized ARM Template for OS-Based Web Server Deployment
Description

In this task, I created an Azure Virtual Machine using an ARM Template with a parameterized OS selection.

The template dynamically deploys different configurations based on the parameter value:

If parameter = Windows → Deploys Windows VM and installs IIS

If parameter = Linux → Deploys Linux VM and installs NGINX

This implementation demonstrates conditional resource deployment using ARM template parameters and conditions.

Objective

To create a reusable Infrastructure-as-Code (IaC) template that:

Accepts OS type as a parameter

Deploys the appropriate VM image

Automatically installs the required web server

Hosts a web service based on selected OS
Logic Implemented
🔹 Condition-Based Deployment

Used ARM template conditions to:

Deploy Windows image if osType = Windows

Deploy Linux image if osType = Linux

Deployment Behavior
✅ Case 1: osType = Windows

Deploys Windows Server VM

Uses Custom Script Extension / PowerShell

<img width="1885" height="982" alt="Screenshot 2026-02-12 163357" src="https://github.com/user-attachments/assets/47022457-2bf4-4f4c-9811-ec7752f9067e" />

Installs IIS using:

Install-WindowsFeature -name Web-Server -IncludeManagementTools


IIS default webpage accessible via Public IP

✅ Case 2: osType = Linux

Deploys Ubuntu VM

Uses Custom Script Extension / cloud-init
/>

Installs NGINX using:

sudo apt update
sudo apt install nginx -y


NGINX default page accessible via Public IP

Steps Performed

1️⃣ Created ARM template 
2️⃣ Defined parameter for OS selection
3️⃣ Used condition logic in resource configuration
4️⃣ Configured appropriate VM image reference
5️⃣ Added OS-specific web server installation script
6️⃣ Deployed template using Azure CLI

<img width="1885" height="982" <img width="1888" height="963" alt="Screenshot 2026-02-10 155231" src="https://github.com/user-attachments/assets/35c023cb-0e02-4781-ac6b-5fed9e7c69af" />




Achieved OS-based conditional deployment

Improved template reusability and automation
