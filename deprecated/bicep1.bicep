@secure()
param containerGroups_r0993343_app_workspaceKey string
param containerGroups_r0993343_app_name string = 'r0993343-app'
param registries_r0993343ContainerRegistry_name string = 'r0993343ContainerRegistry'

resource containerGroups_r0993343_app_name_resource 'Microsoft.ContainerInstance/containerGroups@2024-10-01-preview' = {
  name: containerGroups_r0993343_app_name
  location: 'westeurope'
  zones: [
    '2'
  ]
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: containerGroups_r0993343_app_name
        properties: {
          image: 'r0993343containerregistry.azurecr.io/cloud-platforms/assignment2:latest'
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
    imageRegistryCredentials: [
      {
        server: 'r0993343containerregistry.azurecr.io'
        username: 'r0993343ContainerRegistry'
      }
    ]
    restartPolicy: 'OnFailure'
    ipAddress: {
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      ip: '20.126.225.163'
      type: 'Public'
    }
    osType: 'Linux'
    diagnostics: {
      logAnalytics: {
        workspaceId: 'd895fb43-cb27-45ee-b2a8-6c95a4f22dfc'
        logType: 'ContainerInstanceLogs'
        workspaceKey: containerGroups_r0993343_app_workspaceKey
      }
    }
  }
}

resource registries_r0993343ContainerRegistry_name_resource 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' = {
  name: registries_r0993343ContainerRegistry_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Basic'
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
    anonymousPullEnabled: false
    metadataSearch: 'Disabled'
  }
}

resource registries_r0993343ContainerRegistry_name_repositories_admin 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries_r0993343ContainerRegistry_name_resource
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

resource registries_r0993343ContainerRegistry_name_repositories_pull 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries_r0993343ContainerRegistry_name_resource
  name: '_repositories_pull'
  properties: {
    description: 'Can pull any repository of the registry'
    actions: [
      'repositories/*/content/read'
    ]
  }
}

resource registries_r0993343ContainerRegistry_name_repositories_pull_metadata_read 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries_r0993343ContainerRegistry_name_resource
  name: '_repositories_pull_metadata_read'
  properties: {
    description: 'Can perform all read operations on the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/metadata/read'
    ]
  }
}

resource registries_r0993343ContainerRegistry_name_repositories_push 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries_r0993343ContainerRegistry_name_resource
  name: '_repositories_push'
  properties: {
    description: 'Can push to any repository of the registry'
    actions: [
      'repositories/*/content/read'
      'repositories/*/content/write'
    ]
  }
}

resource registries_r0993343ContainerRegistry_name_repositories_push_metadata_write 'Microsoft.ContainerRegistry/registries/scopeMaps@2024-11-01-preview' = {
  parent: registries_r0993343ContainerRegistry_name_resource
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
