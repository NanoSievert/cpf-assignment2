param location string
param subnet_id string

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'b-r0993343-nsg'
  location: location
  properties: {
    securityRules: [ 
      { //Rule: allow http on inbound
        name: 'AllowHTTP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }, { //Rule: deny all (higher prio => less important => allow only http)
        name: 'DenyAllInbound'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

output nsg_id string = nsg.id
