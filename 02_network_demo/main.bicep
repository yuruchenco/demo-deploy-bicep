//Parameters
@description('Location for all resources')
param location string = resourceGroup().location

@description('Enviroment name')
param enviroment string = 'poc'

@description('Specifies whether creating the vNet resource or not.')
param vNetEnabled bool = true

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true

@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true

@description('Specifies whether creating the bastion resource or not.')
param bastionEnabled bool = true



//Resources

// Deploy vNet
module vNetModule './modules/vnet.bicep' = if (vNetEnabled) {
  name: 'hubVnet'
  params: {
    location: location
    enviroment: enviroment
    hubVnetEnabled:hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
  }
}



//Deploy Azure Bastion
module bastionModule './modules/bastion.bicep' = if (bastionEnabled) {
  name: 'bastion'
  params: {
    location: location
    enviroment: enviroment
    hubVnetName:vNetModule.outputs.OUTPUT_HUB_VNET_NAME
    AzureBastionSubnet:vNetModule.outputs.OUTPUT_BASTION_SUBNET_NAME
    bastionEnabled:bastionEnabled
  }
  dependsOn: [
    vNetModule
  ]
}
