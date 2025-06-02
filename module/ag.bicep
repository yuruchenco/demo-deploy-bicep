@description('System code')
param systemCode string

@description('Environment')
param env string

@description('Name of action groups')
param agName string = 'ag-${systemCode}-${env}'

@description('Short name of action groups')
@minLength(1)
@maxLength(12)
param groupShortName string = 'ag-${systemCode}'

@description('Name of email Address')
param emailAddress string

@description('Name of email Receivers')
param emailReceiversName string

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: agName
  location: 'Global'
  properties: {
    enabled: true
    groupShortName: groupShortName
    emailReceivers: [
      {
        emailAddress: emailAddress
        name: emailReceiversName
        useCommonAlertSchema: true
      }
    ]

  }
}

@description('action group id')
output id string = actionGroup.id
