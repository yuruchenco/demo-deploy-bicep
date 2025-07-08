//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location
@description('Specific System Code')
param systemCode string = 'demo'
@description('Specific Enviroment name')
param environmentName string = 'poc'

// Parameters for action groups
param emailAddress string = 'yuichimasuda@microsoft.com'
param emailReceiversName string = 'yuichimasuda'

var VM_NAME = 'vm-poc-0'

resource vm_name 'Microsoft.Compute/virtualMachines@2022-11-01' existing = {
  name: VM_NAME
}


// deploy action groups.
module ag '../module/ag.bicep' = {
  name: 'Deploy_action_groups'
  params: {
    emailAddress: emailAddress
    emailReceiversName: emailReceiversName
    env: environmentName
    systemCode: systemCode
  }
}

// deploy alert rule.
// deploy alert rule SingleResourceMultipleMetricCriter
module alSingleResourceMultipleMetricCriter '../module/alSingleResourceMultipleMetricCriter.bicep' = {
  name: 'Deploy_alert_rule'
  params: {
    location: location
    env: environmentName
    systemCode: systemCode
    resourceId: vm_name.id
    actionGroupId: ag.outputs.id
  }
}

