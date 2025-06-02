@description('Enviroment name')
param environmentName string = 'poc'
param location string = resourceGroup().location
//param tags object = {}

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true
@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true
@description('Enable private network access to the backend service')
param isPrivateNetworkEnabled bool = true


var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

//Variables
var VNET_SPOKE_NAME = 'vnet-spoke-${environmentName}'
var PE_SPOKE_SUBNET_NAME = 'PrivateEndpointSubnet'

 
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: VNET_SPOKE_NAME
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: PE_SPOKE_SUBNET_NAME
  parent: vnet
}


module appService '../module/appservice.bicep' = {
  name: '${abbrs.webSitesFunctions}${resourceToken}'
  params: {
    appservicePlanName: 'ase-${abbrs.webSitesFunctions}${resourceToken}'
    location: location
    sku: {
      name: 'S1'
      capacity: 1
    }
    kind: 'linux'
    appserviceName: 'app-${abbrs.webSitesFunctions}${resourceToken}'
    publicNetworkAccess: 'Disabled'
  }
}



// ================================================================================================
// PRIVATE ENDPOINT
// ================================================================================================
module appServicePrivateEndopoint '../module/private-endpoint.bicep' = {
  name: 'app-service-private-endpoint'
  params: {
    location: location
    name: appService.outputs.OUTPUT_APPSERVICE_NAME
    subnetId: subnet.id
    privateLinkServiceId: appService.outputs.OUTPUT_APPSERVICE_ID
    privateLinkServiceGroupIds: ['sites']
    dnsZoneName: 'azurewebsites.net'
    linkVnetId: vnet.id
    isPrivateNetworkEnabled: isPrivateNetworkEnabled
  }
  dependsOn: [
    vnet
  ]
}

output AZURE_LOCATION string = location
