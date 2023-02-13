param location string = resourceGroup().location

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-demo-lab'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-demo-lab'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: workspace.id
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
          name: 'ApplicationInsights:ConnectionString'
          value: appInsights.properties.ConnectionString
        }
      ]
    }
  }
}