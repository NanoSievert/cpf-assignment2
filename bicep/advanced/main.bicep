// Static definitions

param location string = 'westeurope'
param registry_login_server string = 'br0993343containerregistry.azurecr.io'

// Prompt registry information
@secure()
param registry_username string // allow admin to insert username

@secure()
param registry_password string // allow admin to insert password

// Module definitions
module network 'Networking.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
  }
}

module security 'Security.bicep' = {
  name: 'securityDeployment'
  params: {
    location: location
    subnet_id: network.outputs.subnet_id
  }
}

module container 'DeployApp.bicep' = {
  name: 'containerDeployment'
  params: {
    registry_username: registry_username
    registry_password: registry_password
    location: location
    subnet_id: network.outputs.subnet_id
    log_analytics_id: network.outputs.log_analytics_id
    registry_login_server: registry_login_server
  }
}
