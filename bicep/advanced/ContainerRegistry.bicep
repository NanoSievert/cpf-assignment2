// Define parameters

param location string = 'westeurope'
param registry_name string = 'br0993343containerregistry'

// Define resources

// Container Registry
resource Container_Registry 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: registry_name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}

output registry_name string = Container_Registry.name
output registry_login_server string = Container_Registry.properties.loginServer
