targetScope = 'tenant'
 
//@description('Provide the full resource ID of billing scope to use for subscription creation.')
//param billingScope string 
@description('The name of the main group')
param mainManagementGroupName string = 'mg-main'
@description('The display name for the main group')
param mainMangementGroupDisplayName string = 'Main Management Group'
param managementGroups array = [
  {
    name: 'mg-project1-non-prod'
    displayName: 'Project1 Non-Prod Management Group'
    subscriptions: [
      {
        name: 'project1-dev'
        workload: 'Production'
      }
      {
        name: 'project1-test'
        workload: 'Production'
      }
    ]
  }
  {
    name: 'mg-project1-prod'
    displayName: 'Project1 Prod Management Group'
    subscriptions: [
      {
        name: 'project1-prod'
        workload: 'Production'
      }
    ]
  }  
  {
    name: 'mg-infrastructure'
    displayName: 'Infrastructure Management Group'   
    subscriptions: [    
      {
        name: 'infrastructure'
        workload: 'Production'
      }
    ]
  }
]
 
resource mainManagementGroup 'Microsoft.Management/managementGroups@2020-02-01' = {
  name: mainManagementGroupName
  scope: tenant()
  properties: {
    displayName: mainMangementGroupDisplayName
  }
}
 
// module subsModule '../module/subs.bicep' = [for group in managementGroups: {
//   name: 'subscriptionDeploy-${group.name}' 
//   params: {
//     subscriptions: group.subscriptions
//     billingScope: billingScope
//   }
// }]
 
// module mgSubModule '../module/mg.bicep' = [for (group, i) in managementGroups: {
//   name: 'managementGroupDeploy-${group.name}'
//   scope: managementGroup(mainManagementGroupName)
//   params: {
//     groupName: group.name
//     groupDisplayName: group.displayName
//     parentId: mainManagementGroup.id
//     subscriptionIds: subsModule[i].outputs.subscriptionIds
//   }
//   dependsOn: [
//     subsModule
//   ]
// }]
