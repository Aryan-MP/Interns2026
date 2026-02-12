#!/bin/bash

# Variables
RESOURCE_GROUP="FardeenAttar-rg"
TEMPLATE_FILE="storage.json"
PARAM_FILE="params.json"
DEPLOYMENT_NAME="mydeployment"

echo "Starting ARM Deployment..."

# Deploy
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --name $DEPLOYMENT_NAME \
  --template-file $TEMPLATE_FILE \
  --parameters $PARAM_FILE \
  --verbose

echo "Deployment Finished. Checking Status..."

# Show Status
az deployment group show \
  --resource-group $RESOURCE_GROUP \
  --name $DEPLOYMENT_NAME \
  --query properties.provisioningState \
  --output table

echo "Listing Resource Operations..."

# List Operations
az deployment operation group list \
  --resource-group $RESOURCE_GROUP \
  --name $DEPLOYMENT_NAME \
  --output table
