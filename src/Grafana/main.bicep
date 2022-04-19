targetScope = 'subscription'

param location string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-dashboard'
  location: location
}

module grafana 'modules/grafana.bicep' = {
  scope: rg
  params: {
    location: 'East US'
    name: 'grafana-dashboard'
  }
  name: 'grafana'
}
