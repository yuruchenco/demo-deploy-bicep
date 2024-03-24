@description('Enviroment name')
param environmentName string = 'poc'
param location string = resourceGroup().location
param tags object = {}

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true
@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true
@description('Enable private network access to the backend service')
param isPrivateNetworkEnabled bool = false

param cosmosDbDatabaseName string = 'ChatHistory'
param cosmosDbContainerName string = 'Prompts'

var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

module vnet '../module/vnet.bicep' = {
  name: 'vnet'
  params: {
    environmentName: environmentName
    hubVnetEnabled: hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
    location: location
  }
}

module cosmosDb '../module/cosmosdb.bicep' = {
  name: 'cosmosdb'
  params: {
    name: '${abbrs.documentDBDatabaseAccounts}${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'cosmosdb' })
    cosmosDbDatabaseName: cosmosDbDatabaseName
    cosmosDbContainerName: cosmosDbContainerName
    publicNetworkAccess: isPrivateNetworkEnabled ? 'Disabled' : 'Enabled'
  }
}


module cosmosDBPrivateEndpoint '../module/private-endpoint.bicep' = {
  name: 'cosmos-private-endpoint'
  params: {
    location: location
    name: cosmosDb.outputs.accountName
    subnetId: vnet.outputs.OUTPUT_PRIVATEENDPOINT_SUBNET_ID
    privateLinkServiceId: cosmosDb.outputs.id
    privateLinkServiceGroupIds: ['SQL']
    dnsZoneName: 'documents.azure.com'
    linkVnetId: vnet.outputs.OUTPUT_SPOKE_VNET_ID
    isPrivateNetworkEnabled: isPrivateNetworkEnabled
  }
  dependsOn: [
    vnet
  ]
}



output AZURE_LOCATION string = location
output AZURE_COSMOSDB_ACCOUNT string = cosmosDb.outputs.accountName
output AZURE_COSMOSDB_ENDPOINT string = cosmosDb.outputs.endpoint
output AZURE_COSMOSDB_DATABASE string = cosmosDb.outputs.databaseName
output AZURE_COSMOSDB_CONTAINER string = cosmosDb.outputs.containerName
