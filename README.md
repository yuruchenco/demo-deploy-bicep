# About demo-deploy-bicep
It is demo repository for deployment using


## Demo description
### 01_network_demo
deploying Azure network resource by mainfile.
* deploying Hub&Spoke vnet & subnet

  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-netowrk_1.bicep
  ```
* deploying Hub&Spoke vnet & subnet & peering
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-netowrk_2.bicep
  ```
* deploying Hub&Spoke vnet & subnet & peering & Bastion
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-netowrk_3.bicep
  ```
  
### 02_network_demo
deploying Azure network resource by mainfile & module files.
* deploying Hub&Spoke vnet & subnet & peering & Bastion
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 03_vm_demo
deploying Azure VM by mainfile.
before deploying vm, you must deploy vnet resource with 01_netowrk_demo or 02 network_demo
* deploying VM on Spoke vnet
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 04_vm_demo
deploying Azure VM by mainfile & module files.
before deploying vm, you must deploy vnet resource with 01_netowrk_demo or 02 network_demo
* deploying VM on Spoke vnet
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-vm.bicep
  ```

### 05_storage_demo
deploying ResourceGroup & StorageAccount by mainfile & module files.
* deploying StorageAccount
  how to deploy with Azure CLI

  ```
   az deployment sub create --template-file main.bicep
  ```
