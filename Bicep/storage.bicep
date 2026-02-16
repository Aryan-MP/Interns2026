targetScope='resourceGroup'

param storageAccountName string
param location string = resourceGroup().location
param containerName string

var storageSku = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
 resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageAccount.name}/default/${containerName}'
  dependsOn: [
    storageAccount
  ]
}

output storageAccountId string = storageAccount.id
output blobContainerId string = blobContainer.name
