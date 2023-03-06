param location string = resourceGroup().location

var prefix = guid('guid')


resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-demo-lab'
  location: location
  kind: 'app'
  sku: {
    // The sku where slot can be used is Standard or higher.
    name: 'S1' 
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
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_TIME_ZONE'
          value: 'Tokyo Standard Time'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

resource slot 'Microsoft.Web/sites/slots@2022-03-01' = {
  name: 'slot'
  parent: app
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '0'
        }
      ]
    }
  }
}

// if you want to set a Deployment slot setting option
// Describe key name in appSettingNames
resource slotSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'slotConfigNames'
  parent: app
  properties: {
    appSettingNames: [
      'WEBSITE_RUN_FROM_PACKAGE'
    ]
  }
}
