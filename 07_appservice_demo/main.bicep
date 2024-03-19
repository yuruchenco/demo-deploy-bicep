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

@description('Specific VM Admin Username')
param VM_ADMIN_USERNAME string = 'azureuser'
@description('Specific VM Admin Password')
@secure()
param vm_admin_password string = 'P@ssw0rd1234'
@description('Specific VM Number')
param vmNumber int = 1

var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))




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

module vmModule '../module/vm.bicep' = [for i in range(0, vmNumber): { 
  name: 'vmModule-${i}'
  params: {
    location: location
    enviroment: environmentName
    vmNumber: i
    VM_ADMIN_USERNAME: VM_ADMIN_USERNAME
    vm_admin_password: vm_admin_password
    vm_subnet_id: vnet.outputs.OUTPUT_VM_SUBNET_ID
  }
}]


// ================================================================================================
// NETWORK
// ================================================================================================
module vnet '../module/vnet.bicep' = {
  name: 'vnet'
  params: {
    enviromentName: environmentName
    hubVnetEnabled: hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
    location: location
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
    subnetId: vnet.outputs.OUTPUT_PRIVATEENDPOINT_SUBNET_ID
    privateLinkServiceId: appService.outputs.OUTPUT_APPSERVICE_ID
    privateLinkServiceGroupIds: ['sites']
    dnsZoneName: 'azurewebsites.net'
    linkVnetId: vnet.outputs.OUTPUT_SPOKE_VNET_ID
    isPrivateNetworkEnabled: isPrivateNetworkEnabled
  }
  dependsOn: [
    vnet
  ]
}

output AZURE_LOCATION string = location
