# Azure VNet and Subnet Allocation Project

## Project Objective

Design and deploy an Azure Virtual Network (VNet) with three subnets
allocated for different teams:

-   Developers -- 30 IP addresses\
-   Security Team -- 20 IP addresses\
-   Cloud Engineers -- 50 IP addresses

Then: 1. Deploy a Virtual Machine in one subnet. 2. Verify the VM's IP
belongs to the assigned subnet. 3. Move the VM to another subnet. 4.
Verify the IP change after subnet modification.

------------------------------------------------------------------------

## Architecture Overview

VNet (10.0.0.0/24)

-   Dev-Subnet (10.0.0.0/27)\
-   Security-Subnet (10.0.0.32/27)\
-   Cloud-Subnet (10.0.0.64/26)

------------------------------------------------------------------------

## IP Address Planning

  Team              Required IPs   CIDR Block   Capacity
  ----------------- -------------- ------------ -----------------------------
  Developers        30             /27          32 IPs (27 usable in Azure)
  Security          20             /27          32 IPs
  Cloud Engineers   50             /26          64 IPs

Note: Azure reserves 5 IP addresses in each subnet.

------------------------------------------------------------------------

## Deployment Steps

### 1. Create Resource Group

az group create --name VNet-RG --location centralindia

------------------------------------------------------------------------

### 2. Create VNet

az network vnet create\
--name Project-VNet\
--resource-group VNet-RG\
--address-prefix 10.0.0.0/24\
--location centralindia

------------------------------------------------------------------------

### 3. Create Subnets

Developer Subnet:

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

## Deploy VM in Dev Subnet

az vm create\
--resource-group VNet-RG\
--name Dev-VM\
--vnet-name Project-VNet\
--subnet Dev-Subnet\
--image Ubuntu2204\
--admin-username azureuser\
--generate-ssh-keys

------------------------------------------------------------------------

## Verify VM Private IP

az vm show\
--resource-group VNet-RG\
--name Dev-VM\
-d\
--query privateIps

The IP should fall within the Dev-Subnet range (10.0.0.0/27).

------------------------------------------------------------------------

## Change VM Subnet

Stop VM:

az vm deallocate --name Dev-VM --resource-group VNet-RG

Update NIC to another subnet:

az network nic ip-config update\
--name ipconfig1\
--nic-name Dev-VMVMNic\
--resource-group VNet-RG\
--subnet Security-Subnet\
--vnet-name Project-VNet

Start VM:

az vm start --name Dev-VM --resource-group VNet-RG

------------------------------------------------------------------------

## Verify Updated IP

az vm show\
--resource-group VNet-RG\
--name Dev-VM\
-d\
--query privateIps

The IP should now fall within the Security-Subnet range (10.0.0.32/27).

------------------------------------------------------------------------

## Key Learnings

-   VNet and subnet CIDR planning
-   Azure reserved IP behavior
-   VM deployment inside a specific subnet
-   Validating subnet IP range
-   Changing subnet using NIC modification
-   Understanding Azure networking design
