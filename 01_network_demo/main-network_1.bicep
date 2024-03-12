//Parameters
@description('Location for all resources')
param location string = resourceGroup().location

@description('Enviroment name')
param enviroment string = 'poc'

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true

@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true




//Variables
//hub vNET resource naming variables
var VNET_HUB_NAME = 'vnet-hub-${enviroment}'
var VNET_HUB_ADDRESS_SPACE = '192.168.0.0/16'
var BASTION_HUB_SUBNET_NAME = 'AzureBastionSubnet'
var BASTION_HUB_SUBNET_ADDRESS_PREFIX = '192.168.1.0/26'
var GW_HUB_SUBNET_NAME = 'GatewaySubnet'
var GW_HUB_SUBNET_ADDRESS_PREFIX = '192.168.2.0/27'

//spoke vNET resource naming variables
var VNET_SPOKE_NAME = 'vnet-spoke-${enviroment}'
var VNET_SPOKE_ADDRESS_SPACE = '172.16.0.0/16'
var VM_SPOKE_SUBNET_NAME = 'VmSubnet'
var VM_SPOKE_SUBNET_ADDRESS_PREFIX = '172.16.0.0/22'


//Resources

// Deploy Hub vNET
resource hubVnet 'Microsoft.Network/virtualNetworks@2021-08-01' = if (hubVnetEnabled) {
  name: VNET_HUB_NAME
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNET_HUB_ADDRESS_SPACE
      ]
    }
    subnets: [
      {
        name: BASTION_HUB_SUBNET_NAME
        properties: {
          addressPrefix: BASTION_HUB_SUBNET_ADDRESS_PREFIX
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
          ]
        }
      }
      {
        name: GW_HUB_SUBNET_NAME
        properties: {
          addressPrefix: GW_HUB_SUBNET_ADDRESS_PREFIX
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
          ]
        }
      }
    ]
  }
}


//Deploy Spoke vNET
resource spokeVnet 'Microsoft.Network/virtualNetworks@2021-08-01' = if (spokeVnetEnabled) {
  name: VNET_SPOKE_NAME
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VNET_SPOKE_ADDRESS_SPACE
      ]
    }
    subnets: [
      {
        name: VM_SPOKE_SUBNET_NAME
        properties: {
          addressPrefix: VM_SPOKE_SUBNET_ADDRESS_PREFIX
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
          ]
        }
      }
    ]
  }
}
