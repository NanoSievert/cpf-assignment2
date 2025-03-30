// Define parameters

// Secure

@secure()
param registry_username string // allow admin to insert username

@secure()
param registry_password string // allow admin to insert password

// Inherited

param location string
param subnet_id string
param log_analytics_id string
param registry_login_server string

// Open

param app_name string = 'b-r0993343-app'
param subscriptionId string = 'b2b2ae69-a262-4b30-b329-c51cd8d65d85'

resource Container_App 'Microsoft.ContainerInstance/containerGroups@2024-10-01-preview' = {
  name: app_name
  location: location
  zones: [
    '2'
  ]
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: app_name
        properties: {
          image: '${registry_login_server}/cloud-platforms/assignment2:latest'
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
        server: registry_login_server
        username: registry_username
        password: registry_password
      }
    ]
    
    restartPolicy: 'OnFailure'
    ipAddress: {
      type: 'Private'  // Use Private IP type
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
    }
    subnetIds: [
      {
        id: subnet_id
      }
    ]
    osType: 'Linux'
  }
}

