//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location
@description('Specific System Code')
param systemCode string = 'demo'
@description('Specific Enviroment name')
param environmentName string = 'poc'

// Parameters for action groups
var APP_SERVICE_NAME = 'acrdemomasuda'
var ACTION_GROUP_NAME = 'RecommendedAlertRules-AG-1'

// reference to existing action group
resource ag 'Microsoft.Insights/actionGroups@2022-06-01' existing = {
  name: ACTION_GROUP_NAME
}

resource app_service 'Microsoft.Web/sites@2022-09-01' existing = {
  name: APP_SERVICE_NAME
  scope: resourceGroup('rg-container-demo')
}


// deploy alert rule.
// deploy alert rule AverageResponseTime
module AverageResponseTime '../module/metricAlert/HttpResponseTime.bicep' = {
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
module Http401 '../module/metricAlert/Http401.bicep' = {
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
module Http406 '../module/metricAlert/Http406.bicep' = {
  name: 'Deploy_alert_rule_Http406'
  params: {
    alertName:'Http406Alert-${app_service.name}-${environmentName}-${systemCode}'
    targetResourceId: [app_service.id]
    targetResourceRegion: location
    targetResourceType: app_service.type
    actionGroupId: ag.id
  }
}

