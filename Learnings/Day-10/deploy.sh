#!/bin/bash

# Azure ARM Template Deployment Script
# This script deploys the VNet infrastructure with public and private subnets

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Azure VNet Deployment Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Configuration
RESOURCE_GROUP="sivakumarderangula-rg"
LOCATION="eastus"
DEPLOYMENT_NAME="vnet-deployment-$(date +%Y%m%d-%H%M%S)"

# Prompt for required parameters
echo -e "${YELLOW}Please provide the following information:${NC}"
echo ""

read -p "Resource Group Name [$RESOURCE_GROUP]: " input
RESOURCE_GROUP="${input:-$RESOURCE_GROUP}"

read -p "Location [$LOCATION]: " input
LOCATION="${input:-$LOCATION}"

read -p "Admin Username [azureuser]: " input
ADMIN_USERNAME="${input:-azureuser}"

echo ""
echo -e "${YELLOW}Choose authentication method:${NC}"
echo "1. SSH Key (recommended)"
echo "2. Password"
read -p "Enter choice [1]: " auth_choice
auth_choice="${auth_choice:-1}"

if [ "$auth_choice" == "1" ]; then
    AUTH_TYPE="sshPublicKey"
    
    # Check if SSH key exists
    if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
        SSH_KEY=$(cat $HOME/.ssh/id_rsa.pub)
        echo -e "${GREEN}Found existing SSH key${NC}"
    else
        echo -e "${YELLOW}No SSH key found. Generating new key...${NC}"
        ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""
        SSH_KEY=$(cat $HOME/.ssh/id_rsa.pub)
    fi
    ADMIN_CREDENTIAL="$SSH_KEY"
else
    AUTH_TYPE="password"
    echo ""
    read -sp "Enter VM Password: " ADMIN_CREDENTIAL
    echo ""
fi

echo ""
read -p "Enter your public IP for SSH access (leave empty for '*' - not recommended): " SOURCE_IP
SOURCE_IP="${SOURCE_IP:-*}"

echo ""
echo -e "${GREEN}Logging in to Azure...${NC}"
az account show > /dev/null 2>&1 || az login

echo ""
echo -e "${GREEN}Creating resource group: $RESOURCE_GROUP${NC}"
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --output table

echo ""
echo -e "${GREEN}Starting deployment: $DEPLOYMENT_NAME${NC}"
echo -e "${YELLOW}This may take 5-10 minutes...${NC}"
echo ""

# Deploy the ARM template
DEPLOYMENT_OUTPUT=$(az deployment group create \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --template-file azuredeploy.json \
    --parameters \
        location="$LOCATION" \
        adminUsername="$ADMIN_USERNAME" \
        authenticationType="$AUTH_TYPE" \
        adminPasswordOrKey="$ADMIN_CREDENTIAL" \
        allowedSourceIP="$SOURCE_IP" \
    --output json)

# Check deployment status
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Deployment Successful!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    
    # Extract outputs
    PUBLIC_IP=$(echo $DEPLOYMENT_OUTPUT | jq -r '.properties.outputs.publicVmIP.value')
    PUBLIC_FQDN=$(echo $DEPLOYMENT_OUTPUT | jq -r '.properties.outputs.publicVmFQDN.value')
    PRIVATE_IP=$(echo $DEPLOYMENT_OUTPUT | jq -r '.properties.outputs.privateVmIP.value')
    WEBSITE_URL=$(echo $DEPLOYMENT_OUTPUT | jq -r '.properties.outputs.websiteUrl.value')
    SSH_COMMAND=$(echo $DEPLOYMENT_OUTPUT | jq -r '.properties.outputs.sshCommand.value')
    
    echo -e "${GREEN}Deployment Information:${NC}"
    echo "----------------------------------------"
    echo "Public VM IP:       $PUBLIC_IP"
    echo "Public VM FQDN:     $PUBLIC_FQDN"
    echo "Private VM IP:      $PRIVATE_IP"
    echo ""
    echo -e "${GREEN}Access Your Website:${NC}"
    echo "URL:                $WEBSITE_URL"
    echo ""
    echo -e "${GREEN}SSH Access:${NC}"
    echo "Command:            $SSH_COMMAND"
    echo ""
    echo -e "${YELLOW}Note: It may take a few minutes for the VMs to complete their setup.${NC}"
    echo -e "${YELLOW}The website will be available after Nginx is installed and configured.${NC}"
    echo ""
    
    # Test website availability
    echo -e "${YELLOW}Testing website availability...${NC}"
    sleep 30  # Wait for VM initialization
    
    for i in {1..10}; do
        if curl -s -o /dev/null -w "%{http_code}" "$WEBSITE_URL" | grep -q "200"; then
            echo -e "${GREEN}✓ Website is now accessible!${NC}"
            echo ""
            break
        else
            echo -e "${YELLOW}Waiting for website to be ready... (attempt $i/10)${NC}"
            sleep 30
        fi
    done
    
    # Save deployment info to file
    cat > deployment-info.txt <<EOF
Azure VNet Deployment Information
==================================
Deployment Name:    $DEPLOYMENT_NAME
Resource Group:     $RESOURCE_GROUP
Location:           $LOCATION
Deployment Date:    $(date)

Network Configuration:
---------------------
VNet:               MyVNet (10.0.0.0/16)
Public Subnet:      PublicSubnet (10.0.1.0/24)
Private Subnet:     PrivateSubnet (10.0.2.0/24)

Virtual Machines:
-----------------
Public VM IP:       $PUBLIC_IP
Public VM FQDN:     $PUBLIC_FQDN
Private VM IP:      $PRIVATE_IP

Access Information:
-------------------
Website URL:        $WEBSITE_URL
SSH to Public VM:   $SSH_COMMAND
SSH to Private VM:  ssh $ADMIN_USERNAME@$PRIVATE_IP (from Public VM)

Security:
---------
Authentication:     $AUTH_TYPE
Allowed SSH IP:     $SOURCE_IP
EOF
    
    echo -e "${GREEN}Deployment information saved to: deployment-info.txt${NC}"
    echo ""
    
else
    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Deployment Failed!${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo "Please check the error messages above."
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Next Steps:${NC}"
echo -e "${GREEN}========================================${NC}"
echo "1. Open your browser and visit: $WEBSITE_URL"
echo "2. SSH to public VM: $SSH_COMMAND"
echo "3. From public VM, SSH to private VM: ssh $ADMIN_USERNAME@$PRIVATE_IP"
echo ""
echo -e "${YELLOW}To delete all resources:${NC}"
echo "az group delete --name $RESOURCE_GROUP --yes --no-wait"
echo ""
