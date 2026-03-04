targetScope = 'resourceGroup'

@description('Storage Account Name (must be globally unique)')
param storageAccountName string

@description('Location')
param location string = resourceGroup().location

@description('Container Name')
param containerName string = 'scripts'

// =============================
// Storage Account
// =============================
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
  }
}

// =============================
// Public Blob Container
// =============================
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storageAccount.name}/default/${containerName}'
  properties: {
    publicAccess: 'Blob'   // Makes blobs public
  }
}





// az storage blob upload \
//  --account-name rishabhstorage12345 \
//  --container-name scripts \
//   --name script.sh \
//   --file script.sh \
//   --auth-mode login




// az storage account keys list \
//   --account-name rishabhstorage12345 \
//   --resource-group <yourRG>




// az storage blob upload \
//   --account-name rishabhstorage12345 \
//   --container-name scripts \
//   --name script.sh \
//   --file script.sh \
//   --account-key <yourKey>




// az storage blob list \
//   --account-name rishabhstorage12345 \
//   --container-name scripts \
//   --auth-mode login \
//   --output table 

