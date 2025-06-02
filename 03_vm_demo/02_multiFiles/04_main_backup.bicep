//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location
@description('Specific System Code')
param systemCode string = 'demo'
@description('Specific Enviroment name')
param environmentName string = 'poc'

// Parameters for action groups
param vaultName string = 'vault-vm'
param emailReceiversName string = 'yuichimasuda'


var VM_NAME = 'vm-poc-0'
var BACKUP_FABRIC = 'Azure'
var BACKUP_POLICY_NAME = 'DefaultPolicy'
var PROTECTION_CONTAINER = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${VM_NAME}'
var PROTECTED_ITEM = 'vm;iaasvmcontainerv2;${resourceGroup().name};${VM_NAME}'

resource vm_name 'Microsoft.Compute/virtualMachines@2022-11-01' existing = {
  name: VM_NAME
}

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2020-02-02' = {
  name: vaultName
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}
}

resource vaultName_backupFabric_protectionContainer_protectedItem 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2020-02-02' = {
  name: '${vaultName}/${BACKUP_FABRIC}/${PROTECTION_CONTAINER}/${PROTECTED_ITEM}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: '${recoveryServicesVault.id}/backupPolicies/${BACKUP_POLICY_NAME}'
    sourceResourceId: vm_name.id
  }
  dependsOn:[
    recoveryServicesVault
  ]
} 


