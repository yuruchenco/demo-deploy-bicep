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




var VNET_SPOKE_NAME = 'vnet-spoke-${environmentName}'
var VM_SPOKE_SUBNET_NAME = 'VmSubnet'

//Resources 
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: VNET_SPOKE_NAME
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: VM_SPOKE_SUBNET_NAME
  parent: vnet
}


module vmModule '../../Module/vm.bicep' = [for i in range(0, vmNumber): { 
  name: 'vmModule-${i}'
  params: {
    location: location
    environmentName: environmentName
    vmNumber: i
    VM_ADMIN_USERNAME: vm_admin_username
    vm_admin_password: vm_admin_password
    vm_subnet_id: subnet.id
  }
}]


