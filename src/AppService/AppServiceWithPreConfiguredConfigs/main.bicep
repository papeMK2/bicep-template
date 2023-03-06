param location string = resourceGroup().location

var prefix = guid('guid')


resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-demo-lab'
  location: location
  kind: 'app'
  sku: {
    name: 'B1'
  }
}

resource app 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-demo-lab-${prefix}'
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
  }
}

var config = {
  WEBSITE_TIME_ZONE: 'Tokyo Standard Time'
  WEBSITE_RUN_FROM_PACKAGE: '1'
}

var configuredConfig = list('${app.id}/config/appsettings', '2022-03-01').properties


module appSettings 'modules/appConfig.bicep' = {
  name: 'settings-app-demo-lab-${prefix}'
  params: {
    config: config
    configuredConfig: configuredConfig
    parentName: app.name
  }
}
