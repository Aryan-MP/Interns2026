# Azure Reverse Proxy + Private VM Architecture

## Overview

This ARM template deploys a secure two-tier architecture in Azure:

-   Public Proxy VM (Jumpbox)
-   Private Backend VM
-   NAT Gateway for outbound internet
-   NGINX installed on both VMs
-   Reverse Proxy configuration

------------------------------------------------------------------------

## 1. Parameters

Defines reusable deployment inputs: - **adminUsername** -- VM login
username\
- **adminPassword** -- Secure password\
- **location** -- Deployment region (default: centralindia)

------------------------------------------------------------------------

## 2. Variables

Stores reusable resource names: - Virtual Network name\
- VM names\
- Public IP names

------------------------------------------------------------------------

## 3. NAT Public IP

Creates a Static Standard Public IP. Used by the NAT Gateway for
outbound internet access.

------------------------------------------------------------------------

## 4. NAT Gateway

Provides outbound internet for the private subnet. Traffic flow: Private
VM → NAT Gateway → Public IP → Internet

------------------------------------------------------------------------

## 5. Network Security Group (NSG)

Attached to Proxy VM. Allows inbound HTTP (Port 80). Blocks all other
inbound traffic.

------------------------------------------------------------------------

## 6. Virtual Network (VNet)

Address Space: 10.0.0.0/16

Subnets: - Public Subnet (10.0.0.0/24) - Private Subnet (10.0.1.0/24)

Private subnet is associated with NAT Gateway.

------------------------------------------------------------------------

## 7. Proxy Public IP

Public IP attached to Proxy VM. Used by users to access the application.

------------------------------------------------------------------------

## 8. Proxy Network Interface

Connects Proxy VM to: - Public subnet - Public IP - NSG

------------------------------------------------------------------------

## 9. Private Network Interface

Static private IP: 10.0.1.4 No public IP. Only accessible within VNet.

------------------------------------------------------------------------

## 10. Proxy VM

Ubuntu VM in Public Subnet. Acts as Reverse Proxy. Size:
Standard_D2ls_v5

------------------------------------------------------------------------

## 11. Private VM

Ubuntu VM in Private Subnet. Hosts NGINX web server. Not accessible from
internet.

------------------------------------------------------------------------

## 12. Private VM Extension

Installs NGINX and deploys webpage: "Hello from PRIVATE VM via Reverse
Proxy"

------------------------------------------------------------------------

## 13. Proxy VM Extension

Installs NGINX and configures reverse proxy: proxy_pass http://10.0.1.4;

------------------------------------------------------------------------

## Traffic Flow

User Browser → Proxy Public IP\
Proxy VM → Forwards to 10.0.1.4\
Private VM → Sends response\
Proxy VM → Returns response to user

Private VM is never directly exposed to the internet.

------------------------------------------------------------------------

## Architecture Pattern

-   Secure two-tier design
-   Reverse proxy pattern
-   Private backend isolation
-   Controlled outbound access via NAT Gateway
