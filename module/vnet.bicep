//Parameters
@description('Location for all resources')
param location string = resourceGroup().location

@description('Enviroment name')
param enviroment string = 'poc'

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool

@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool




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
var VM_SPOKE_SUBNET_ADDRESS_PREFIX = '172.16.0.0/26'
var AppService_SPOKE_SUBNET_NAME = 'AppserviceSubnet'
var AppService_SPOKE_SUBNET_ADDRESS_PREFIX = '172.16.1.0/26'

//hub vNET & spoke vNET peering variables
var VNET_HUB_TO_SPOKE_PEERING = '${VNET_HUB_NAME}-to-${VNET_SPOKE_NAME}'
var VNET_SPOKE_TO_HUB_PEERING = '${VNET_SPOKE_NAME}-to-${VNET_HUB_NAME}'

//NSG VM SPOKE SUBNET inbound rules variables
var NSG_VM_SPOKE_SUBNET_INBOUND_NAME = 'nsg_inbound-${VM_SPOKE_SUBNET_NAME}'
var NSG_DEFAULT_VM_SPOKE_SUBNET_RULES = loadJsonContent('./default-rule-spoke-nsg.json', 'DefaultRules')



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
          // networkSecurityGroup: {
          //   id: nsginboundspoke.id
          // }
        }
      }
      {
        name: AppService_SPOKE_SUBNET_NAME
        properties: {
          addressPrefix: AppService_SPOKE_SUBNET_ADDRESS_PREFIX
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

// Deploy NSG for spokeVnet
resource nsginboundspoke 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: NSG_VM_SPOKE_SUBNET_INBOUND_NAME
  location: location
  properties: {
    securityRules: NSG_DEFAULT_VM_SPOKE_SUBNET_RULES
  }
}

//Deploy Hub vNET to Spoke vNET peering
resource hubVnetToSpokeVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = if (hubVnetEnabled && spokeVnetEnabled) {
  name: VNET_HUB_TO_SPOKE_PEERING
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

//Deploy Spoke vNET to Hub vNET peering
resource spokeVnetToHubVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-08-01' = if (hubVnetEnabled && spokeVnetEnabled) {
  name: VNET_SPOKE_TO_HUB_PEERING
  parent: spokeVnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output OUTPUT_HUB_VNET_NAME string = hubVnet.name
output OUTPUT_SPOKE_VNET_NAME string = spokeVnet.name
output OUTPUT_SPOKE_VNET_ID string = spokeVnet.id
output OUTPUT_APPSERVICE_SUBNET_NAME string = spokeVnet.properties.subnets[1].name
output OUTPUT_APPSERVICE_SUBNET_ID string = spokeVnet.properties.subnets[1].id
output OUTPUT_BASTION_SUBNET_NAME string = hubVnet.properties.subnets[0].name
