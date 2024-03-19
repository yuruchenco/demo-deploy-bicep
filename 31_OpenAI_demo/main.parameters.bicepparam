using 'main.bicep' /*TODO: Provide a path to a bicep template*/

param environmentName = '\${AZURE_ENV_NAME}'
param location = '\${AZURE_LOCATION}'
param resourceGroupName = '\${AZURE_RESOURCE_GROUP}'
param isPrivateNetworkEnabled = false
param principalId = '\${AZURE_PRINCIPAL_ID}'
param openAiServiceName = '\${AZURE_OPENAI_SERVICE}'
param openAiResourceGroupName = '\${AZURE_OPENAI_RESOURCE_GROUP}'
param openAiSkuName = 'S0'
param formRecognizerServiceName = '\${AZURE_FORMRECOGNIZER_SERVICE}'
param formRecognizerResourceGroupName = '\${AZURE_FORMRECOGNIZER_RESOURCE_GROUP}'
param formRecognizerSkuName = 'S0'
param searchServiceName = '\${AZURE_SEARCH_SERVICE}'
param searchServiceResourceGroupName = '\${AZURE_SEARCH_SERVICE_RESOURCE_GROUP}'
param searchServiceSkuName = 'standard'
param storageAccountName = '\${AZURE_STORAGE_ACCOUNT}'
param storageResourceGroupName = '\${AZURE_STORAGE_RESOURCE_GROUP}'
//param appInsightsInstrumentationKey = '\${AZURE_APPINSIGHTS_INSTRUMENTATION_KEY}'
param principalType = '\${AZURE_PRINCIPAL_TYPE}'