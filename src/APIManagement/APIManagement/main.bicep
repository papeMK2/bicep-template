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
