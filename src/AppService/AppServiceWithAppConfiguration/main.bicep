param location string = resourceGroup().location

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: 'appcs-demo-lab'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'free'
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-demo-lab'
  location: location
  kind: 'app'
  sku: {
    name: 'B1'
  }
}

resource app 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-demo-lab'
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AppConfig:Endpoint'
          value: appConfiguration.properties.endpoint
        }
      ]
    }
  }
}

var roleDefinitionAppConfigurationDataReader = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071')
resource managedId 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(app.name, app.id, roleDefinitionAppConfigurationDataReader)
  properties: {
    principalId: app.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: roleDefinitionAppConfigurationDataReader
  }
}
