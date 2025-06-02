//Parameters
@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string
param location string
param publicNetworkAccess string
param vnetname string
param subnetname string

//storage account variables
var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    //publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: subnetname
          action: 'Allow'
        }
      ]
    }
  }
}

output OUTPUT_STORAGE_ENDPOINT object = storage.properties.primaryEndpoints
output OUTPUT_NAME string = storage.name
output OUTPUT_ID string = storage.id
