//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location
@description('Specific System Code')
param systemCode string = 'demo'
@description('Specific Enviroment name')
param environmentName string = 'poc'

// Parameters for action groups
var APP_SERVICE_NAME = 'acrdemomasuda'
var SQL_SERVER_NAME = 'demo-masuda-sql-server'
var SQL_DATABASE_NAME = 'demo-sql-database'
var AZURE_CONTAINER_REGISTRY_NAME = 'acrdemomasuda'
var ACTION_GROUP_NAME = 'RecommendedAlertRules-AG-1'

// reference to existing action group
resource ag 'Microsoft.Insights/actionGroups@2022-06-01' existing = {
  name: ACTION_GROUP_NAME
}

resource app_service 'Microsoft.Web/sites@2022-09-01' existing = {
  name: APP_SERVICE_NAME
  scope: resourceGroup('rg-container-demo')
}

resource sql_server 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: SQL_SERVER_NAME
  scope: resourceGroup('rg-sqldatabase')
}

resource sql_database 'Microsoft.Sql/servers/databases@2021-11-01' existing = {
  name: SQL_DATABASE_NAME
  parent: sql_server
}

resource azure_container_registry 'Microsoft.ContainerRegistry/registries@2022-12-01' existing = {
  name: AZURE_CONTAINER_REGISTRY_NAME
  scope: resourceGroup('rg-container-demo')
}


// deploy alert rule.

// deploy for App Service
// deploy alert rule AverageResponseTime
module AverageResponseTime '../module/metricAlert/AppService/HttpResponseTime.bicep' = {
  name: 'Deploy_alert_rule_AverageResponseTime'
  params: {
    alertName:'AverageResponseTimeAlert-${app_service.name}-${environmentName}-${systemCode}'
    targetResourceId: [app_service.id]
    targetResourceRegion: location
    targetResourceType: app_service.type
    actionGroupId: ag.id
  }
}

// deploy alert rule Http401
module Http401 '../module/metricAlert/AppService/Http401.bicep' = {
  name: 'Deploy_alert_rule_Http401'
  params: {
    alertName:'Http401Alert-${app_service.name}-${environmentName}-${systemCode}'
    targetResourceId: [app_service.id]
    targetResourceRegion: location
    targetResourceType: app_service.type
    actionGroupId: ag.id
  }
}

//deploy alert rule Http406
module Http406 '../module/metricAlert/AppService/Http406.bicep' = {
  name: 'Deploy_alert_rule_Http406'
  params: {
    alertName:'Http406Alert-${app_service.name}-${environmentName}-${systemCode}'
    targetResourceId: [app_service.id]
    targetResourceRegion: location
    targetResourceType: app_service.type
    actionGroupId: ag.id
  }
}

//Alert for SQL Satabase
//deploy alert rule BlockedByFirewall
module BlockedByFirewall '../module/metricAlert/SQLServer/BlockedByFirewall.bicep' = {
  name: 'Deploy_alert_rule_BlockedByFirewall'
  params: {
    alertName:'BlockedByFirewallAlert-${sql_database.name}-${environmentName}-${systemCode}'
    targetResourceId: [sql_database.id]
    targetResourceRegion: location
    targetResourceType: sql_database.type
    actionGroupId: ag.id
  }
}

//deploy alert storage
module Storage '../module/metricAlert/SQLServer/Storage.bicep' = {
  name: 'Deploy_alert_rule_Storage'
  params: {
    alertName:'StorageAlert-${sql_database.name}-${environmentName}-${systemCode}'
    targetResourceId: [sql_database.id]
    targetResourceRegion: location
    targetResourceType: sql_database.type
    actionGroupId: ag.id
  }
}

//deploy alert rule TempdbDataSize
module TempdbDataSize '../module/metricAlert/SQLServer/TempdbDataSize.bicep' = {
  name: 'Deploy_alert_rule_TempdbDataSize'
  params: {
    alertName:'TempdbDataSizeAlert-${sql_database.name}-${environmentName}-${systemCode}'
    targetResourceId: [sql_database.id]
    targetResourceRegion: location
    targetResourceType: sql_database.type
    actionGroupId: ag.id
  }
}


