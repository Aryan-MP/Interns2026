param storageAccountName string
param location string = resourceGroup().location
param skuName string = 'Standard_LRS' // Other options: Standard_GRS, Standard_ZRS, Premium_LRS

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2' // General-purpose v2 storage
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountId string = storageAccount.id
output storageAccountNameOut string = storageAccount.name
