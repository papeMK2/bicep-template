param location string = resourceGroup().location

var prefix = guid('guid')

resource apim 'Microsoft.ApiManagement/service@2022-04-01-preview' = {
  name: 'apim-demo-lab-${prefix}'
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0 // Consumption plan must be specified as 0
  }
  properties: {
    publisherEmail: 'info@example.com'
    publisherName: 'example'
  }
}

resource redis 'Microsoft.Cache/redis@2022-06-01' = {
  name: 'redis-demo-lab-${prefix}'
  location: location
  properties: {
    sku: {
      name: 'Basic'
      capacity: 0
      family: 'C'
    }
    redisVersion: 'latest'
  }
}

resource apim_cache 'Microsoft.ApiManagement/service/caches@2022-04-01-preview' = {
  name: 'apim-cache-demo-lab-${prefix}'
  parent: apim
  properties: {
    connectionString: '${redis.properties.hostName},password=${redis.listKeys().primaryKey},ssl=True,abortConnect=False'
    useFromLocation: redis.location
    description: redis.properties.hostName
  }
}
