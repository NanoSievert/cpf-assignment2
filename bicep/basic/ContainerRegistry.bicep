// Define parameters

param registry_name string = 'br0993343containerregistry'

// Define resources

// Container Registry
resource Container_Registry 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: registry_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}
