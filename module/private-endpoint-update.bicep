param location string = resourceGroup().location
param dnsZoneName string
param linkVnetId string
param name string
param subnetId string
param privateLinkServiceId string
param privateLinkServiceGroupIds array
param isPrivateNetworkEnabled bool


// Reference existing private DNS zone (if needed)
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.${dnsZoneName}'
  scope: resourceGroup()
}


// https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/private-link/private-endpoint-overview.md
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-02-01' = if (isPrivateNetworkEnabled) {
  name: '${name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${name}-connection}'
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: privateLinkServiceGroupIds
        }
      }
    ]
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = if (isPrivateNetworkEnabled) {
  parent: privateEndpoint
  name: '${name}-dns-zone-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'private-link-${name}'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

output privateEndpointId string = privateEndpoint.id
output privateEndpointName string = privateEndpoint.name
