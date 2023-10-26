//Parameters
@description('Location for all resources')
param location string = resourceGroup().location

@description('Enviroment name')
param enviroment string = 'poc'

param hubVnetName string

param AzureBastionSubnet string

@description('Specifies whether creating the bastion resource or not.')
param bastionEnabled bool = true


//Variables


// Azure Bastion variables
var BASTION_NAME = 'bastion-${enviroment}'
var BASTION_IF_NAME = 'bastionipconf-${enviroment}'
var BASTION_SKU = 'Standard'
var BASTION_PIP_NAME = 'bastionpip-${enviroment}'
var BASTION_PIP_SKU = 'Standard'
var BASTION_PIP_ALLOCATION_METHOD = 'Static'

//Resources

// Reference the existing SpokeVNET
resource existingHubvnet 'Microsoft.Network/virtualNetworks@2020-05-01' existing = {
  name: hubVnetName
  resource existingvmsubnet 'subnets' existing = {
    name: AzureBastionSubnet
  }
}


// Deploy public IP for Azure Bastion
resource bastionPip 'Microsoft.Network/publicIPAddresses@2020-05-01' = {
  name: BASTION_PIP_NAME
  location: location
  sku: {
    name: BASTION_PIP_SKU
  }
  properties: {
    publicIPAllocationMethod: BASTION_PIP_ALLOCATION_METHOD
  }
}

//Deploy Azure Bastion
resource bastion 'Microsoft.Network/bastionHosts@2021-08-01' = if (bastionEnabled) {
  name: BASTION_NAME
  location: location
  sku: {
    name: BASTION_SKU
  }
  properties: {
    ipConfigurations: [
      {
        name: BASTION_IF_NAME
        properties: {
          subnet: {
            id: existingHubvnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: bastionPip.id
          }
        }
      }
    ]
  }
}
