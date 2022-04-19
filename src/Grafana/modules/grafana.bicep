@allowed([
  'East US'
  'West Europe'
  'South Central US'
  'West Central US'
])
param location string

param name string

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
