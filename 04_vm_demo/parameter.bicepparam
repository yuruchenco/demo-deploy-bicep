using 'main_init.bicep'

param location  = 'japaneast'

@description('Specific Enviroment name')
param environmentName  = 'poc'

@description('Specific VM Number')
param vmNumber  = 1

@description('Specific VM Admin Username')
param vm_admin_username  = 'azureuser'

@description('Specific VM Admin Password')
@secure()
param vm_admin_password  = 'P@ssw0rd1234'

@description('Specifies whether creating the vNet resource or not.')
param vNetEnabled  = true

@description('Specifies whether creating the hubVnet resource or not.')
param hubVnetEnabled  = true

@description('Specifies whether creating the spokeVnet resource or not.')
param spokeVnetEnabled  = true

