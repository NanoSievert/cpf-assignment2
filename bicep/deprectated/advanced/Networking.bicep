param location string

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'b-r0993343-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'b-r0993343-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'Microsoft.ContainerInstance/containerGroups'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'
              }
              type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
            }
          ]
        }
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'b-r0993343-publicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'b-r0993343-logs'
  location: location
  properties: {}
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-11-01' = {
  name: 'b-r0993343-lb'
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'b-r0993343-frontendIP'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'b-r0993343-backendPool'
      }
    ]
    loadBalancingRules: [
      {
        name: 'http-rule'
        properties: {
          frontendIPConfiguration: {
            id: loadBalancer.properties.frontendIPConfigurations[0].id
          }
          backendAddressPool: {
            id: loadBalancer.properties.backendAddressPools[0].id
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          probe: {
            name: 'http-probe'
            properties: {
              protocol: 'Http'
              port: 80
              requestPath: '/'
              intervalInSeconds: 5
              numberOfProbes: 2
            }
          }
        }
      }
    ]
  }
}


output vnet object = vnet
output subnet_id string = vnet.properties.subnets[0].id
output public_ip_id string = publicIP.id
output log_analytics_id string = logAnalytics.id


