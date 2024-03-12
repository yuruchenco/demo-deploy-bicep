targetScope = 'subscription'

param resourceGroupName string = 'rg-AzureDevOpsDemo'
param location string = 'japaneast'
param appServiceName string = 'AzureDevOpsDemo'
@description('Enviroment name')
param enviroment string = 'poc'
@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true
@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module vnet '../module/vnet.bicep' = {
  name: 'vnet'
  scope: resourceGroup
  params: {
    enviroment: enviroment
    hubVnetEnabled: hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
    location: location
  }
}


module appService '../module/appservice.bicep' = {
  name: 'app-service'
  scope: resourceGroup
  params: {
    appservicePlanName: 'ase-${appServiceName}'
    location: location
    sku: {
      name: 'S1'
      capacity: 1
    }
    kind: 'linux'
    appserviceName: 'app-${appServiceName}'
    publicNetworkAccess: 'Disabled'
  }
}


module appServicePrivateEndpoint '../module/private-endpoint.bicep' = {
  name: 'app-service-private-endpoint'
  scope: resourceGroup
  params: {
    name: appService.outputs.OUTPUT_APPSERVICE_NAME
    location: location
    subnetId: vnet.outputs.OUTPUT_APPSERVICE_SUBNET_ID
    privateLinkServiceId: appService.outputs.OUTPUT_APPSERVICE_ID
    privateLinkServiceGroupIds: ['sites']
    dnsZoneName: 'azurewebsites.net'
    linkVnetId: vnet.outputs.OUTPUT_SPOKE_VNET_ID
  }
}
