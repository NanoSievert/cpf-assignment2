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

output vnet object = vnet
output subnet_id string = vnet.properties.subnets[0].id
output public_ip_id string = publicIP.id
output log_analytics_id string = logAnalytics.id
