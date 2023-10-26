targetScope = 'subscription'

//Parameters
param resourceGroupName string = 'exampleRG2'
param resourceGroupLocation string = 'westus'
param storagePrefix string = 'bicepsa'
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
param storageSKU string = 'Standard_LRS'


//Variables



//Resources

// リソースグループの作成
resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module storageAccount 'modules/sotrageAccount.bicep' = {
  name: 'storageAccount'
  scope: newRG
  params: {
    storagePrefix:storagePrefix
    storageSKU: storageSKU
    location: resourceGroupLocation
  }
}
