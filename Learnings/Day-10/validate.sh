#!/bin/bash

# Deployment Validation Script
# Tests the deployed infrastructure to ensure everything is working correctly

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
RESOURCE_GROUP="sivakumarderangula-rg"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Azure Deployment Validation Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Prompt for resource group
read -p "Resource Group Name [$RESOURCE_GROUP]: " input
RESOURCE_GROUP="${input:-$RESOURCE_GROUP}"

echo ""
echo -e "${YELLOW}Starting validation...${NC}"
echo ""

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=10

# Function to print test result
test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        ((TESTS_FAILED++))
    fi
}

echo -e "${BLUE}[1/10] Checking Resource Group...${NC}"
az group show --name "$RESOURCE_GROUP" > /dev/null 2>&1
test_result $? "Resource group '$RESOURCE_GROUP' exists"
echo ""

echo -e "${BLUE}[2/10] Checking Virtual Network...${NC}"
VNET=$(az network vnet show --resource-group "$RESOURCE_GROUP" --name "MyVNet" --query name -o tsv 2>/dev/null)
if [ "$VNET" == "MyVNet" ]; then
    test_result 0 "Virtual Network 'MyVNet' exists"
else
    test_result 1 "Virtual Network 'MyVNet' not found"
fi
echo ""

echo -e "${BLUE}[3/10] Checking Subnets...${NC}"
PUBLIC_SUBNET=$(az network vnet subnet show --resource-group "$RESOURCE_GROUP" --vnet-name "MyVNet" --name "PublicSubnet" --query name -o tsv 2>/dev/null)
PRIVATE_SUBNET=$(az network vnet subnet show --resource-group "$RESOURCE_GROUP" --vnet-name "MyVNet" --name "PrivateSubnet" --query name -o tsv 2>/dev/null)

if [ "$PUBLIC_SUBNET" == "PublicSubnet" ]; then
    test_result 0 "Public Subnet exists"
else
    test_result 1 "Public Subnet not found"
fi

if [ "$PRIVATE_SUBNET" == "PrivateSubnet" ]; then
    test_result 0 "Private Subnet exists"
else
    test_result 1 "Private Subnet not found"
fi
echo ""

echo -e "${BLUE}[4/10] Checking Network Security Groups...${NC}"
PUBLIC_NSG=$(az network nsg show --resource-group "$RESOURCE_GROUP" --name "PublicSubnet-NSG" --query name -o tsv 2>/dev/null)
PRIVATE_NSG=$(az network nsg show --resource-group "$RESOURCE_GROUP" --name "PrivateSubnet-NSG" --query name -o tsv 2>/dev/null)

if [ "$PUBLIC_NSG" == "PublicSubnet-NSG" ]; then
    test_result 0 "Public NSG exists"
else
    test_result 1 "Public NSG not found"
fi

if [ "$PRIVATE_NSG" == "PrivateSubnet-NSG" ]; then
    test_result 0 "Private NSG exists"
else
    test_result 1 "Private NSG not found"
fi
echo ""

echo -e "${BLUE}[5/10] Checking Virtual Machines...${NC}"
PUBLIC_VM=$(az vm show --resource-group "$RESOURCE_GROUP" --name "PublicVM" --query name -o tsv 2>/dev/null)
PRIVATE_VM=$(az vm show --resource-group "$RESOURCE_GROUP" --name "PrivateVM" --query name -o tsv 2>/dev/null)

if [ "$PUBLIC_VM" == "PublicVM" ]; then
    test_result 0 "Public VM exists"
else
    test_result 1 "Public VM not found"
fi

if [ "$PRIVATE_VM" == "PrivateVM" ]; then
    test_result 0 "Private VM exists"
else
    test_result 1 "Private VM not found"
fi
echo ""

echo -e "${BLUE}[6/10] Checking VM Power State...${NC}"
PUBLIC_VM_STATE=$(az vm get-instance-view --resource-group "$RESOURCE_GROUP" --name "PublicVM" --query "instanceView.statuses[1].displayStatus" -o tsv 2>/dev/null)
PRIVATE_VM_STATE=$(az vm get-instance-view --resource-group "$RESOURCE_GROUP" --name "PrivateVM" --query "instanceView.statuses[1].displayStatus" -o tsv 2>/dev/null)

if [ "$PUBLIC_VM_STATE" == "VM running" ]; then
    test_result 0 "Public VM is running"
else
    test_result 1 "Public VM is not running (State: $PUBLIC_VM_STATE)"
fi

if [ "$PRIVATE_VM_STATE" == "VM running" ]; then
    test_result 0 "Private VM is running"
else
    test_result 1 "Private VM is not running (State: $PRIVATE_VM_STATE)"
fi
echo ""

echo -e "${BLUE}[7/10] Checking Public IP Address...${NC}"
PUBLIC_IP=$(az network public-ip show --resource-group "$RESOURCE_GROUP" --name "PublicVM-IP" --query ipAddress -o tsv 2>/dev/null)
if [ ! -z "$PUBLIC_IP" ]; then
    test_result 0 "Public IP allocated: $PUBLIC_IP"
else
    test_result 1 "Public IP not allocated"
fi
echo ""

echo -e "${BLUE}[8/10] Checking Private VM has no Public IP...${NC}"
PRIVATE_NIC_IP=$(az vm show --resource-group "$RESOURCE_GROUP" --name "PrivateVM" --query "networkProfile.networkInterfaces[0].id" -o tsv)
PRIVATE_NIC_NAME=$(basename "$PRIVATE_NIC_IP")
PRIVATE_PUBLIC_IP=$(az network nic show --ids "$PRIVATE_NIC_IP" --query "ipConfigurations[0].publicIPAddress" -o tsv 2>/dev/null)

if [ -z "$PRIVATE_PUBLIC_IP" ] || [ "$PRIVATE_PUBLIC_IP" == "null" ]; then
    test_result 0 "Private VM has no public IP (as expected)"
else
    test_result 1 "Private VM has a public IP (should not have one)"
fi
echo ""

echo -e "${BLUE}[9/10] Testing Website Accessibility...${NC}"
if [ ! -z "$PUBLIC_IP" ]; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://$PUBLIC_IP" --connect-timeout 10 --max-time 20)
    if [ "$HTTP_CODE" == "200" ]; then
        test_result 0 "Website is accessible (HTTP 200)"
    else
        test_result 1 "Website returned HTTP $HTTP_CODE (may still be initializing)"
    fi
else
    test_result 1 "Cannot test website - Public IP not found"
fi
echo ""

echo -e "${BLUE}[10/10] Checking NSG Rules...${NC}"
HTTP_RULE=$(az network nsg rule show --resource-group "$RESOURCE_GROUP" --nsg-name "PublicSubnet-NSG" --name "Allow-HTTP" --query name -o tsv 2>/dev/null)
if [ "$HTTP_RULE" == "Allow-HTTP" ]; then
    test_result 0 "HTTP rule configured on Public NSG"
else
    test_result 1 "HTTP rule not found on Public NSG"
fi
echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Validation Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Total Tests: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! Your deployment is successful.${NC}"
    echo ""
    echo -e "${GREEN}Access Information:${NC}"
    echo "----------------------------------------"
    echo "Website URL:    http://$PUBLIC_IP"
    echo "SSH to Public:  ssh azureuser@$PUBLIC_IP"
    echo "SSH to Private: ssh azureuser@10.0.2.4 (from Public VM)"
    echo ""
else
    echo -e "${YELLOW}⚠️  Some tests failed. Please review the errors above.${NC}"
    echo ""
    echo "Common issues:"
    echo "- VMs may still be initializing (wait 2-3 minutes)"
    echo "- Cloud-init scripts may still be running"
    echo "- Network connectivity issues"
    echo ""
    echo "To check VM boot diagnostics:"
    echo "az vm boot-diagnostics get-boot-log --resource-group $RESOURCE_GROUP --name PublicVM"
    echo "az vm boot-diagnostics get-boot-log --resource-group $RESOURCE_GROUP --name PrivateVM"
    echo ""
fi

# Detailed resource information
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Detailed Resource Information${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ ! -z "$PUBLIC_IP" ]; then
    echo -e "${YELLOW}Public VM:${NC}"
    az vm show --resource-group "$RESOURCE_GROUP" --name "PublicVM" --query "{Name:name, Size:hardwareProfile.vmSize, State:provisioningState}" -o table
    echo ""
    
    echo -e "${YELLOW}Private VM:${NC}"
    PRIVATE_IP=$(az network nic show --ids "$PRIVATE_NIC_IP" --query "ipConfigurations[0].privateIPAddress" -o tsv)
    az vm show --resource-group "$RESOURCE_GROUP" --name "PrivateVM" --query "{Name:name, Size:hardwareProfile.vmSize, State:provisioningState}" -o table
    echo "Private IP: $PRIVATE_IP"
    echo ""
    
    echo -e "${YELLOW}Network Security Groups:${NC}"
    echo "Public NSG Rules:"
    az network nsg rule list --resource-group "$RESOURCE_GROUP" --nsg-name "PublicSubnet-NSG" --query "[].{Priority:priority, Name:name, Port:destinationPortRange, Source:sourceAddressPrefix, Access:access}" -o table
    echo ""
    
    echo "Private NSG Rules:"
    az network nsg rule list --resource-group "$RESOURCE_GROUP" --nsg-name "PrivateSubnet-NSG" --query "[].{Priority:priority, Name:name, Port:destinationPortRange, Source:sourceAddressPrefix, Access:access}" -o table
    echo ""
fi

echo -e "${GREEN}Validation complete!${NC}"
