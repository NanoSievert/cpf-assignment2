// Define parameters

@secure()
param registry_username string // allow admin to insert username

@secure()
param registry_password string // allow admin to insert password

param app_name string = 'b-r0993343-app'

resource Container_App 'Microsoft.ContainerInstance/containerGroups@2024-10-01-preview' = {
  name: app_name
  location: 'westeurope'
  zones: [
    '2'
  ]
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
    imageRegistryCredentials: [
      {
        server: 'br0993343containerregistry.azurecr.io'
        username: registry_username
        password: registry_password
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
      type: 'Public'
    }
    osType: 'Linux'
  }
}
