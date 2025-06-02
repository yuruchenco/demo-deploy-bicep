@description('Provide a location for the registry.')
param location string = resourceGroup().location
@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string = 'acr${uniqueString(resourceGroup().id)}'
@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

module acrResource '../module/acr.bicep' = {
  name: acrName
  params: {
    location: location
    acrName: acrName
    acrSku: acrSku
  }
}
