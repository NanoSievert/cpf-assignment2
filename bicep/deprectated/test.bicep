// Define parameters

@secure()
param app_workspaceKey string = 'pelikaan123'
param registry_name string = 'br0993343containerregistry'
param app_name string = 'b-r0993343-app'

// Define resources

// Container Registry
resource Container_Registry 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: registry_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
      azureADAuthenticationAsArmPolicy: {
        status: 'enabled'
      }
      softDeletePolicy: {
        retentionDays: 7
        status: 'disabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: true
    metadataSearch: 'Disabled'
  }
}

resource Container_App 'Microsoft.ContainerInstance/containerGroups@2024-10-01-preview' = {
  name: app_name
  location: 'westeurope'
  zones: [
    '2'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: app_name
        properties: {
          image: 'br0993343containerregistry.azurecr.io/cloud-platforms/assignment2:latest'
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          environmentVariables: []
          resources: {
            requests: {
              memoryInGB: json('1.5')
              cpu: json('1')
            }
          }
        }
      }
    ]
    initContainers: []
    imageRegistryCredentials: []
    restartPolicy: 'OnFailure'
    ipAddress: {
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      type: 'Public'
    }
    osType: 'Linux'
  }
}

resource ContainerRegistry_name_repositories_admin 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: Container_Registry
  name: '_repositories_admin'
  properties: {
    description: 'Can perform all read, write and delete operations on the registry'
    actions: [
      'repositories/*/metadata/read'
      'repositories/*/metadata/write'
      'repositories/*/content/read'
      'repositories/*/content/write'
      'repositories/*/content/delete'
    ]
  }
}

resource ContainerRegistry_name_repositories_pull 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: Container_Registry
  name: '_repositories_pull'
  properties: {
    description: 'Can pull any repository of the registry'
    actions: [
      'repositories/*/content/read'
    ]
  }
}

resource ContainerRegistry_name_repositories_pull_metadata_read 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: Container_Registry
  name: '_repositories_pull_metadata_read'
  properties: {
    description: 'Can perform all read operations on the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/metadata/read'
    ]
  }
}

resource ContainerRegistry_name_repositories_push 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: Container_Registry
  name: '_repositories_push'
  properties: {
    description: 'Can push to any repository of the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}

resource ContainerRegistry_name_repositories_push_metadata_write 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: Container_Registry
  name: '_repositories_push_metadata_write'
  properties: {
    description: 'Can perform all read and write operations on the registry'
    actions: [
      'repositories/*/metadata/read'
      'repositories/*/metadata/write'
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}
