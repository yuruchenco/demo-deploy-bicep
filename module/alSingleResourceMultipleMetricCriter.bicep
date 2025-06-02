@description('Location for all resources.')
param location string

@description('System code')
param systemCode string

@description('Environment')
param env string

@description('Name of alert rule')
param alName string = 'vm-${systemCode}-${env} is down'

@description('Description of alert')
param alertDescription string = 'This is a metric alert'

@description('Severity of alert {0,1,2,3,4}')
@allowed([
  0
  1
  2
  3
  4
])
param alertSeverity int = 1

@description('Specifies whether the alert is enabled')
param isEnabled bool = true

@description('Full Resource ID of the resource emitting the metric that will be used for the comparison. For example /subscriptions/00000000-0000-0000-0000-0000-00000000/resourceGroups/ResourceGroupName/providers/Microsoft.compute/virtualMachines/VM_xyz')
@minLength(1)
param resourceId string

@description('Period of time used to monitor alert activity based on the threshold. Must be between five minutes and one hour. ISO 8601 duration format.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
])
param windowSize string = 'PT1M'

@description('how often the metric alert is evaluated represented in ISO 8601 duration format')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
])
param evaluationFrequency string = 'PT1M'

@description('the flag that indicates whether the alert should be auto resolved or not. The default is true.')
param autoMitigate bool = true

param targetResourceType string = 'Microsoft.Compute/virtualMachines'

@description('action group id')
param actionGroupId string

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: alName
  location: 'global'
  properties: {
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: '1st criterion'
          metricName: 'VmAvailabilityMetric'
          dimensions: []
          operator: 'LessThan'
          threshold: 1
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    description: alertDescription
    enabled: isEnabled
    evaluationFrequency: evaluationFrequency
    scopes: [
      resourceId
    ]
    severity: alertSeverity
    windowSize: windowSize
    autoMitigate: autoMitigate
    targetResourceType: targetResourceType
    targetResourceRegion: location
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}
