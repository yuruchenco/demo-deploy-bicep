@description('Enviroment name')
param environmentName string = 'poc'
param location string = resourceGroup().location
param tags object = {}

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true
@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true
@description('Enable private network access to the backend service')
param isPrivateNetworkEnabled bool = true

param cosmosDbDatabaseName string = 'ChatHistoryUpdate'
param cosmosDbContainerName string = 'PromptsUpdate'

var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))


module cosmosDb '../module/cosmosdb_update.bicep' = {
  name: 'cosmosdb'
  params: {
    name: 'cosmos-qr4qnrnib6ggo'
    // location: location
    // tags: union(tags, { 'azd-service-name': 'cosmosdb' })
    cosmosDbDatabaseName: cosmosDbDatabaseName
    cosmosDbContainerName: cosmosDbContainerName
    // publicNetworkAccess: isPrivateNetworkEnabled ? 'Disabled' : 'Enabled'
  }
}




output AZURE_LOCATION string = location
// output AZURE_COSMOSDB_ACCOUNT string = cosmosDb.outputs.accountName
// output AZURE_COSMOSDB_ENDPOINT string = cosmosDb.outputs.endpoint
output AZURE_COSMOSDB_DATABASE string = cosmosDb.outputs.databaseName
output AZURE_COSMOSDB_CONTAINER string = cosmosDb.outputs.containerName
