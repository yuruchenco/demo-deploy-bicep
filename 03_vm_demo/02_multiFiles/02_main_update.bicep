//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location

@description('Specific Enviroment name')
param environmentName string = 'poc'


var VM_NAME = 'vm-poc-0'


resource LawAmpls 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing ={
  name: 'law-ampls'
}

resource AMPLS 'microsoft.insights/privateLinkScopes@2021-07-01-preview' existing = {
  name: 'ampls'
}

// To execute "resource~existing" after "CreateVM" module, include process in the same module and use "dependsOn"
module DCRDCE '../../module/DCRDCE_linux.bicep' = {
  name: 'attachDcrDce'
  params: {
    location: location
    vmName: VM_NAME
    LawName: LawAmpls.name
    LawId: LawAmpls.id
  }
}

// Connect Data Collection Endpoint to AMPLS
resource AmplsScopedDCE 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  name: 'amplsScopedDCE'
  parent: AMPLS
  properties: {
    linkedResourceId: DCRDCE.outputs.DCEWindowsId
  }
}

