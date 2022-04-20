@allowed([
  'East US'
  'West Europe'
  'South Central US'
  'West Central US'
])
param location string

param name string

param roleDefinitionResourceId string
param principalId string

resource grafana 'Microsoft.Dashboard/grafana@2021-09-01-preview' = {
  name: name
  location: location

  sku: {
    name: 'Standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: grafana
  name: guid(grafana.id, principalId, roleDefinitionResourceId)
  properties: {
    roleDefinitionId: roleDefinitionResourceId
    principalId: principalId
    
  }
}
