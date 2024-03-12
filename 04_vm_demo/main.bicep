//Parameters
@description('Specific Location for all resources')
param location string = resourceGroup().location

@description('Specific Enviroment name')
param enviroment string = 'poc'

@description('Specific VM Number')
param vmNumber int = 1

@description('Specific VM Admin Username')
param VM_ADMIN_USERNAME string = 'azureuser'

@description('Specific VM Admin Password')
@secure()
param vm_admin_password string = 'P@ssw0rd1234'




//Resources 

module vmModule 'modules/vm.bicep' = [for i in range(0, vmNumber): { 
  name: 'vmModule-${i}'
  params: {
    location: location
    enviroment: enviroment
    vmNumber: i
    VM_ADMIN_USERNAME: VM_ADMIN_USERNAME
    vm_admin_password: vm_admin_password
  }
}]
