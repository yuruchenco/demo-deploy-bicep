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


//Resources 

module vNetModule '../Module/vnet.bicep' = if (vNetEnabled) {
  name: 'hubVnet'
  params: {
    location: location
    environmentName: environmentName
    hubVnetEnabled:hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
  }
}

module applicationGatewayModule '../Module/applicationGateway.bicep' = {
  name: 'appGateway'
  params: {
    location: location
    environmentName: environmentName
    subnetID: vNetModule.outputs.OUTPUT_APPGW_SUBNET_ID
  }
}


