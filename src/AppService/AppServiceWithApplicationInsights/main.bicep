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
    Request_Source: 'rest'
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

          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'recommended'
        }
        {
          // enable visual studio's snapshot debugger site extension feature.
          name: 'SnapshotDebugger_EXTENSION_VERSION'
          value: '~1'
        }
        {
          // enable snapshot debugger
          name: 'APPINSIGHTS_SNAPSHOTFEATURE_VERSION'
          value: '1.0.0'
        }
        {
          // enable application insights profiler
          name: 'DiagnosticServices_EXTENSION_VERSION'
          value: '~3'
        }
        {
          // enable binary-rewrite engine
          // if you want to show local variables for your application when an exception is thrown, 
          // DiagnosticServices_EXTENSION_VERSION and this are need.
          name: 'InstrumentationEngine_EXTENSION_VERSION'
          value: '~1'
        }
      ]
    }
  }
}
