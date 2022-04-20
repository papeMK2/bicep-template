targetScope = 'subscription'

param location string

param principalId string
param grafanaViewerRoleId string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-dashboard'
  location: location
}

resource grafanaViewerRole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: grafanaViewerRoleId
}

module grafana 'modules/grafana.bicep' = {
  scope: rg
  params: {
    roleDefinitionResourceId: grafanaViewerRole.id
    principalId: principalId
    location: 'East US'
    name: 'grafana-dashboard'
  }
  name: 'grafana'
}
