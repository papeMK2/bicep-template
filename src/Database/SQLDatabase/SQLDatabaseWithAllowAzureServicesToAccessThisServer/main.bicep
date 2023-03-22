
param location string = resourceGroup().location

param login string = 'papemk2'
@secure()
param password string = '!qaz2wsx3edc'

var suffix = guid('guid')

resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
  name: 'sql-${suffix}'
  location: location
  properties: {
    administratorLogin: login
    administratorLoginPassword: password
  }
}

resource db 'Microsoft.Sql/servers/databases@2022-08-01-preview' = {
  name: 'sqldb-${suffix}'
  parent: sqlServer
  location: location
  sku: {
    name: 'GP_S_Gen5'
    family: 'Gen5'
    capacity: 1
  }
}

resource firewall 'Microsoft.Sql/servers/firewallRules@2022-08-01-preview' = {
  name: 'AllowAllWindowsAzureIps'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
