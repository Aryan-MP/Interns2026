# Azure Virtual Network Design & Subnet Allocation Project

## Overview

This project demonstrates the design and implementation of a structured
Azure Virtual Network (VNet) with subnet segmentation based on
organizational team requirements. The exercise includes subnet IP
planning, VM deployment, IP validation, and subnet reassignment
validation.

This project is designed to showcase practical Azure networking
knowledge including CIDR planning, subnet allocation, NIC configuration,
and VM networking validation.

------------------------------------------------------------------------

## Architecture Design

### Virtual Network

-   Address Space: **10.0.0.0/24**
-   Region: **Central India**

### Subnet Allocation Strategy

  ------------------------------------------------------------------------------------------------
  Team         Required Hosts   Subnet            CIDR           Total IPs    Usable IPs (Azure)
  ------------ ---------------- ----------------- -------------- ------------ --------------------
  Developers   30               Dev-Subnet        10.0.0.0/27    32           27

  Security     20               Security-Subnet   10.0.0.32/27   32           27

  Cloud        50               Cloud-Subnet      10.0.0.64/26   64           59
  Engineers                                                                   
  ------------------------------------------------------------------------------------------------

> Note: Azure reserves 5 IP addresses in every subnet.

------------------------------------------------------------------------

## Deployment Steps

### 1. Create Resource Group

az group create --name VNet-RG --location centralindia

------------------------------------------------------------------------

### 2. Create Virtual Network

az network vnet create\
--name Project-VNet\
--resource-group VNet-RG\
--address-prefix 10.0.0.0/24\
--location centralindia

------------------------------------------------------------------------

### 3. Create Subnets

Dev Subnet:

az network vnet subnet create\
--resource-group VNet-RG\
--vnet-name Project-VNet\
--name Dev-Subnet\
--address-prefix 10.0.0.0/27

Security Subnet:

az network vnet subnet create\
--resource-group VNet-RG\
--vnet-name Project-VNet\
--name Security-Subnet\
--address-prefix 10.0.0.32/27

Cloud Engineers Subnet:

az network vnet subnet create\
--resource-group VNet-RG\
--vnet-name Project-VNet\
--name Cloud-Subnet\
--address-prefix 10.0.0.64/26

------------------------------------------------------------------------

## Virtual Machine Deployment

Deploy a Linux VM inside the Developer subnet:

az vm create\
--resource-group VNet-RG\
--name Dev-VM\
--vnet-name Project-VNet\
--subnet Dev-Subnet\
--image Ubuntu2204\
--admin-username azureuser\
--generate-ssh-keys

------------------------------------------------------------------------

## IP Validation Process

### Step 1: Verify Private IP

az vm show\
--resource-group VNet-RG\
--name Dev-VM\
-d\
--query privateIps

Expected Result:\
The IP must fall within **10.0.0.0 -- 10.0.0.31** (Dev-Subnet range).

------------------------------------------------------------------------

## Changing Subnet Assignment

### Step 1: Deallocate VM

az vm deallocate --name Dev-VM --resource-group VNet-RG

### Step 2: Update NIC to Security Subnet

az network nic ip-config update\
--name ipconfig1\
--nic-name Dev-VMVMNic\
--resource-group VNet-RG\
--subnet Security-Subnet\
--vnet-name Project-VNet

### Step 3: Restart VM

az vm start --name Dev-VM --resource-group VNet-RG

------------------------------------------------------------------------

## Post-Change Verification

Run:

az vm show\
--resource-group VNet-RG\
--name Dev-VM\
-d\
--query privateIps

Expected Result:\
The IP should now fall within **10.0.0.32 -- 10.0.0.63**
(Security-Subnet range).

------------------------------------------------------------------------

## Key Concepts Demonstrated

-   CIDR-based subnet planning
-   Azure IP reservation rules
-   VM deployment in a specific subnet
-   Private IP validation
-   NIC reconfiguration
-   Subnet reassignment and IP change behavior
-   Practical Azure CLI usage

------------------------------------------------------------------------

## Skills Showcased

-   Azure Networking Fundamentals
-   Infrastructure Provisioning
-   Resource Segmentation
-   IP Planning Strategy
-   CLI-Based Automation
-   Troubleshooting & Validation

------------------------------------------------------------------------

## Conclusion

This project validates understanding of Azure Virtual Network design
principles and practical VM networking behavior. It demonstrates the
ability to plan subnet allocations, deploy infrastructure, validate
network assignments, and perform subnet migration effectively.
