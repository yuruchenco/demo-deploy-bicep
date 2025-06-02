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



