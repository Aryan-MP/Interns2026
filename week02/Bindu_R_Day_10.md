Task: Secure Private VM Hosting in Virtual Network
Description
In this task, I designed a secure Azure network architecture using a Virtual Network (VNet) with multiple subnets. A Virtual Machine was deployed in a private subnet with no public IP, ensuring maximum security.

The VM hosts a static HTML website, which is accessed securely without exposing the VM directly to the internet.

🎯 Goal
Host a .html website inside a Private VM

Access the website securely

Keep the Private VM fully protected from public exposure

Architecture Overview

Created a Virtual Network with two subnets

Deployed a VM in the private subnet

Disabled public IP assignment

Configured secure access mechanisms

Installed required packages inside the VM

Hosted static web content

Components Used

Azure Virtual Network (VNet)

Private Subnet

Virtual Machine (Private IP only)

Network Security Group (NSG)

Secure access method (Jump VM / Bastion / VPN)

Web Server (IIS / NGINX)

Steps Performed
1️⃣ Virtual Network and Subnet Creation

Created a Virtual Network

Configured two subnets:

Public/Management subnet (for secure access)

Private subnet (for application VM)

2️⃣ Private VM Deployment

Deployed a Virtual Machine inside the private subnet

Assigned Private IP only (no Public IP)

Ensured VM is not directly reachable from the internet

3️⃣ Security Configuration

Applied Network Security Group rules

Allowed only required internal traffic

Blocked inbound internet access

Restricted SSH/RDP access to trusted sources only

4️⃣ Secure Access to Private VM

Used a secure method to access the VM:

Jump Host VM / Bastion / VPN connection

Logged into the private VM through the secure channel
