//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location

@description('Specific Enviroment name')
param environmentName string = 'poc'

@description('Specific VM Number')
param vmNumber int = 1

@description('Specific VM Admin Username')
param vm_admin_username string

@description('Specific VM Admin Password')
@secure()
param vm_admin_password string

@description('Specifies whether creating the vNet resource or not.')
param vNetEnabled bool = true

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled bool = true

@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled bool = true


//Resources 

module vNetModule '../Module/vnet.bicep' = if (vNetEnabled) {
  //scope: resourceGroup
  name: 'hubVnet'
  params: {
    location: location
    environmentName: environmentName
    hubVnetEnabled:hubVnetEnabled
    spokeVnetEnabled:spokeVnetEnabled
  }
}


module vmModule '../Module/vm.bicep' = [for i in range(0, vmNumber): { 
  name: 'vmModule-${i}'
  params: {
    location: location
    environmentName: environmentName
    vmNumber: i
    VM_ADMIN_USERNAME: vm_admin_username
    vm_admin_password: vm_admin_password
    vm_subnet_id: vNetModule.outputs.OUTPUT_VM_SUBNET_ID
  }
}]


