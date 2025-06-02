//Parameters
@description('Location for all resources')
param location string
@description('Enviroment name')
param environmentName string
@description('VM Number')
param vmNumber int
@description('VM Admin Username')
param VM_ADMIN_USERNAME string
@description('VM Admin Password')
param vm_admin_password string
param vm_subnet_id string



//Variables
 var VM_NAME = 'vm-${environmentName}-${vmNumber}'
 var VM_SIZE = 'Standard_B1s'
 var VM_IMAGE_PUBLISHER = 'Canonical'
 var VM_IMAGE_OFFER = 'UbuntuServer'
 var VM_IMAGE_SKU = '18.04-LTS'
 var VM_IMAGE_VERSION = 'latest'
 var VM_OS_DISK_NAME = 'osdisk-${environmentName}-${VM_NAME}'
 var VM_OS_DISK_CREATE_OPTION = 'FromImage'
 var VM_OS_DISK_CACHING = 'ReadWrite'
 var VM_OS_MANAGED_DISK_REDUNDANCY = 'Standard_LRS'
 var VM_OS_DISK_SIZE = 60
 var VM_DATA_DISK_NAME = 'datadisk-${environmentName}-${VM_NAME}'
 var VM_DATA_DISK_SIZE = 1023
 var VM_DATA_DISK_CREATE_OPTION = 'Empty'
 var VM_DATA_DISK_CACHING = 'ReadOnly'
 var VM_DATA_DISK_LUN = 0
 var VM_DATA_MANAGED_DISK_REDUNDANCY = 'StandardSSD_LRS'
 //nic variables
 var VM_NIC_NAME = 'nic-${environmentName}-${VM_NAME}'
 var IP_CONFIG_NAME = 'ipconfig1'
 var PRIVATE_IP_AllOCATION_METHOD = 'Dynamic'
//ManagedID variables
 var MANAGED_IDENTITY_NAME = 'managedIdentity-${environmentName}-${VM_NAME}' 



//Deploy nic
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: VM_NIC_NAME
  location: location
  tags: {
    DeptCode: 'biceptest'
  }
  properties: {
    ipConfigurations: [
      {
        name: IP_CONFIG_NAME
        properties: {
          subnet: {
            id: vm_subnet_id
          }
          privateIPAllocationMethod: PRIVATE_IP_AllOCATION_METHOD
        }
      }
    ]
  }
}


//Deploy vm
resource vm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: VM_NAME
  location: location
  properties:{
    hardwareProfile: {
      vmSize: VM_SIZE
    }
    storageProfile: {
      imageReference: {
        publisher: VM_IMAGE_PUBLISHER
        offer: VM_IMAGE_OFFER
        sku: VM_IMAGE_SKU
        version: VM_IMAGE_VERSION
      }
      osDisk: {
        name: VM_OS_DISK_NAME
        createOption: VM_OS_DISK_CREATE_OPTION
        osType: 'Linux'
        caching: VM_OS_DISK_CACHING
        managedDisk: {
          //id: disk.id
          storageAccountType: VM_OS_MANAGED_DISK_REDUNDANCY
        }
        diskSizeGB: VM_OS_DISK_SIZE
      }
      dataDisks: [
        {
          name: VM_DATA_DISK_NAME
          createOption: VM_DATA_DISK_CREATE_OPTION
          caching: VM_DATA_DISK_CACHING
          diskSizeGB: VM_DATA_DISK_SIZE
          lun: VM_DATA_DISK_LUN
          managedDisk:{
            storageAccountType: VM_DATA_MANAGED_DISK_REDUNDANCY
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile:{
      computerName: VM_NAME
      adminUsername: VM_ADMIN_USERNAME
      adminPassword: vm_admin_password
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: MANAGED_IDENTITY_NAME
  location: location
}


resource linuxAgent 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = {
  name: 'AzureMonitorLinuxAgent'
  parent: vm
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorLinuxAgent'
    typeHandlerVersion: '1.21'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {
      authentication: {
        managedIdentity: {
          'identifier-name': 'mi_res_id'
          'identifier-value': managedIdentity.id
        }
      }
    }
  }
}

