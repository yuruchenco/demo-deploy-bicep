//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location

@description('policyDefinitionName')
param policyAssignmentName string = 'Configure Dependency agent on Arc Linux with Monitor Agent'

@description('ID of the policy definition')
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/08a4470f-b26d-428d-97f4-7e3e9c92b366'

@description('ID of the dcr resource')
param dcrResourceId string = '/subscriptions/7fd24fa5-b36e-4da0-bb40-2cd734d5fb2b/resourceGroups/rg-bicep-policy/providers/Microsoft.Insights/dataCollectionRules/dcr-bicep-policy'

@description('User Assigned Managed Identity')
param bringYourOwnUserAssignedManagedIdentity bool = false


resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: policyAssignmentName
    location: location
    //scope: subscriptionResourceId('Microsoft.Resources/resourceGroups', resourceGroup().name)
    properties: {
        policyDefinitionId: policyDefinitionID
    }
    identity: {
      type: 'SystemAssigned'
  }
}

output assignmentId string = assignment.id
