//Parameters
@description('Location for all resources')
param location string = resourceGroup().location

@description('Enviroment name')
param environmentName string = 'poc'

@description('Specifies whether creating the hubVnet resource or not.')
param vNetEnabled bool




//Variables
//hub vNET resource naming variables
var VNET_HUB_NAME = 'vnetcc001'
var VNET_HUB_ADDRESS_SPACE = '10.0.0.0/16'
var SUBNET_ADMIN_NAME = 'admin'
var SUBNET_ADMIN_ADDRESS_PREFIX = '10.0.0.0/24'
var SUBNET_ANF_NAME = 'anf'
var SUBNET_ANF_ADDRESS_PREFIX = '10.0.2.0/24'
var SUBNET_COMPUTE_NAME = 'compute'
var SUBNET_COMPUTE_ADDRESS_PREFIX = '10.0.4.0/24'


//Resources

// Deploy Hub vNET
resource Vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = if (vNetEnabled) {
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
        name: SUBNET_ADMIN_NAME
        properties: {
          addressPrefix: SUBNET_ADMIN_ADDRESS_PREFIX
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
          ]
        }
      }
      {
        name: SUBNET_ANF_NAME
        properties: {
          addressPrefix: SUBNET_ANF_ADDRESS_PREFIX
          serviceEndpoints: [
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
          ]
          delegations: [
            {
              name: 'anf'
              properties: {
                serviceName: 'Microsoft.Netapp/volumes'
              }
            }
          ]
        }
      }
      {
        name: SUBNET_COMPUTE_NAME
        properties: {
          addressPrefix: SUBNET_COMPUTE_ADDRESS_PREFIX
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

output OUTPUT_HUB_VNET_NAME string = Vnet.name
output OUTPUT_HUB_VNET_ID string = Vnet.id
output OUTPUT_ADMIN_SUBNET_NAME string = Vnet.properties.subnets[0].name
output OUTPUT_ADMIN_SUBNET_ID string = Vnet.properties.subnets[0].id
output OUTPUT_ANF_SUBNET_NAME string = Vnet.properties.subnets[1].name
output OUTPUT_ANF_SUBNET_ID string = Vnet.properties.subnets[1].id
output OUTPUT_COMPUTE_SUBNET_NAME string = Vnet.properties.subnets[2].name
output OUTPUT_COMPUTE_SUBNET_ID string = Vnet.properties.subnets[2].id
