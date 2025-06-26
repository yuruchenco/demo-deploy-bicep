# About demo-deploy-bicep
It is demo repository for deployment using Azure Bicep templates.


## Demo description
### 01_network_demo
deploying Azure network resource by mainfile.
* deploying Hub&Spoke vnet & subnet

  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-network_1.bicep
  ```
* deploying Hub&Spoke vnet & subnet & peering
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-network_2.bicep
  ```
* deploying Hub&Spoke vnet & subnet & peering & Bastion
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main-network_3.bicep
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
before deploying vm, you must deploy vnet resource with 01_network_demo or 02_network_demo
* deploying VM on Spoke vnet
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 04_vm_demo
deploying Azure VM by mainfile & module files.
before deploying vm, you must deploy vnet resource with 01_network_demo or 02_network_demo
* deploying VM on Spoke vnet
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main_init.bicep
  ```

### 05_storage_demo
deploying ResourceGroup & StorageAccount by mainfile & module files.
* deploying StorageAccount
  how to deploy with Azure CLI

  ```
   az deployment sub create --template-file main.bicep
  ```

### 06_aks_demo
deploying Azure Kubernetes Service (AKS) cluster.
* deploying AKS cluster with SSH key authentication
  how to deploy with Azure CLI

  ```
  az deployment group create --resource-group [your resourcegroupname] --template-file ./main.bicep --parameters sshRSAPublicKey='<ssh-key>'
  ```

  For detailed deployment instructions including SSH key generation, see [06_aks_demo/read.md](./06_aks_demo/read.md)

### 07_appservice_demo
deploying Azure App Service with private network access.
* deploying App Service with private endpoints
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 08_firewall
deploying Azure Firewall from exported template.
* Contains exported Azure Resource Manager templates for firewall deployment
  Templates are located in the ExportedTemplate directory

### 09_cosmosDB
deploying Azure Cosmos DB with module files.
* deploying Cosmos DB with database and container
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 10_Azure_policy
deploying Azure Policy assignments.
* deploying policy assignment for dependency agent configuration
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 11_applicationGateway_demo
deploying Azure Application Gateway with VNet.
* deploying Application Gateway on Hub&Spoke network
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 31_OpenAI_demo
deploying Azure OpenAI service with supporting infrastructure.
* deploying OpenAI service with search, app service, and monitoring
  how to deploy with Azure CLI

  ```
  az deployment sub create --template-file main.bicep --parameters @main.parameters.json
  ```

### 32_HPC
deploying High Performance Computing (HPC) infrastructure.
* deploying HPC VNet and VM resources
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 51_Subscription
deploying subscription-level resources and management groups.
* deploying management group hierarchy and subscriptions
  how to deploy with Azure CLI

  ```
  az deployment tenant create --template-file main.bicep
  ```

### 61_ACR
deploying Azure Container Registry.
* deploying ACR with module files
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main.bicep
  ```

### 62_AMPLS
deploying Azure Monitor Private Link Scope.
* deploying AMPLS with private DNS zones and private endpoints
  how to deploy with Azure CLI

  ```
  az deployment group create --name myDeployment --resource-group [your resourcegroupname] --template-file ./main_.bicep
  ```
