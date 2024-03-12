param appservicePlanName string
param location string = resourceGroup().location
//App Service Plan 
param sku object
param kind string = ''
//App Service
param appserviceName string
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string


resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appservicePlanName
  location: location
  sku: sku
  kind: kind
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appserviceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: publicNetworkAccess
  }
}

output OUTPUT_APPSERVICE_PLAN_ID string = appServicePlan.id
output OUTPUT_APPSERVICE_PLAN_NAME string = appServicePlan.name
output OUTPUT_APPSERVICE_ID string = appService.id
output OUTPUT_APPSERVICE_NAME string = appService.name

