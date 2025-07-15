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
var SEARCH_SERVICE_NAME = 'as-masuda-demo'
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

resource search_service 'Microsoft.Search/searchServices@2020-08-01' existing = {
  name: SEARCH_SERVICE_NAME
  scope: resourceGroup('rg-aisearch')
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


//Alert for SearchService
//deploy Activity Log alert rule SearchServiceDelete
module ActivityLogSearchServiceDelete '../module/activityAlert/ActivityLogSearchServiceDelete.bicep' = {
  name: 'Deploy_activity_log_alert_rule_SearchServiceDelete'
  params: {
    alertName:'SearchServiceDeleteAlert-${search_service.name}-${environmentName}-${systemCode}'
    actionGroupId: ag.id
  }
}


//deploy SearchLatency
module SearchLatency '../module/metricAlert/SearchService/SearchLatency.bicep' = {
  name: 'Deploy_alert_rule_SearchLatency'
  params: {
    alertName:'SearchLatencyAlert-${search_service.name}-${environmentName}-${systemCode}'
    targetResourceId: [search_service.id]
    targetResourceRegion: location
    targetResourceType: search_service.type
    actionGroupId: ag.id
  }
}

//deploy ThrottledSearchQueriesPercentage
module ThrottledSearchQueriesPercentage '../module/metricAlert/SearchService/ThrottledSearchQueriesPercentage.bicep' = {
  name: 'Deploy_alert_rule_ThrottledSearchQueriesPercentage'
  params: {
    alertName:'ThrottledSearchQueriesPercentageAlert-${search_service.name}-${environmentName}-${systemCode}'
    targetResourceId: [search_service.id]
    targetResourceRegion: location
    targetResourceType: search_service.type
    actionGroupId: ag.id
  }
} 
