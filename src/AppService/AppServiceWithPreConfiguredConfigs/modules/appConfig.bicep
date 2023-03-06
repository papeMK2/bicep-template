param parentName string

param configuredConfig object
param config object

resource app 'Microsoft.Web/sites@2022-03-01' existing = {
  name: parentName
}

var mergedConfig = union(configuredConfig, config)

resource sitConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'appsettings'
  parent: app
  properties: mergedConfig
}
