//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location
@description('Specific Enviroment name')
param environmentName string = 'poc'

@description('Specifies whether creating the vNet resource or not.')
param vNetEnabled bool = true
@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true
@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true

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
param publicEnabled string = 'Disabled'
param isPrivateNetworkEnabled bool = true


//Variables



//Resources
module vNet '../module/vnet.bicep' = if (vNetEnabled) {
  //scope: resourceGroup
  name: 'Vnet'
  params: {
    location: location
    environmentName: environmentName
    hubVnetEnabled:hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
  }
}


module storageAccount '../module/storageAccount.bicep' = {
  name: 'storageAccount'
  params: {
    storagePrefix:storagePrefix
    storageSKU: storageSKU
    location: location
    publicNetworkAccess: publicEnabled
    vnetname: vNet.outputs.OUTPUT_SPOKE_VNET_NAME
    subnetname: vNet.outputs.OUTPUT_VM_SUBNET_ID
  }
}



module storagePrivateEndopoint '../module/private-endpoint.bicep' = {
  name: 'storage-private-endpoint'
  params: {
    location: location
    name: storageAccount.outputs.OUTPUT_NAME
    subnetId: vNet.outputs.OUTPUT_PRIVATEENDPOINT_SUBNET_ID
    privateLinkServiceId: storageAccount.outputs.OUTPUT_ID
    privateLinkServiceGroupIds: ['Blob']
    dnsZoneName: 'blob.core.windows.net'
    linkVnetId: vNet.outputs.OUTPUT_SPOKE_VNET_ID
    isPrivateNetworkEnabled: isPrivateNetworkEnabled
  }
  dependsOn: [
    vNet
  ]
}
