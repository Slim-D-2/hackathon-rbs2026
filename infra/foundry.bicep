targetScope = 'resourceGroup'

@description('Azure region in which to deploy the Foundry resource, project, and model.')
param location string

@description('Globally unique name for the Microsoft Foundry resource.')
@minLength(2)
@maxLength(64)
param foundryName string

@description('Name of the Microsoft Foundry project.')
@minLength(2)
@maxLength(64)
param foundryProjectName string

@description('Display name for the Microsoft Foundry project.')
param foundryProjectDisplayName string = foundryProjectName

@description('Description displayed for the Microsoft Foundry project.')
param foundryProjectDescription string = 'Hackathon Microsoft Foundry project.'

@description('Name exposed to applications for the LLM deployment.')
param deploymentName string

@description('Model name available in the selected Azure region.')
param modelName string

@description('Model version available in the selected Azure region.')
param modelVersion string

@description('Deployment SKU for the selected model.')
param deploymentSkuName string

@description('Model deployment capacity in thousands of tokens per minute.')
@minValue(1)
param deploymentCapacity int

@description('Whether the Foundry endpoint accepts public network traffic.')
param publicNetworkAccess string

@description('Tags applied to all supported resources.')
param tags object

// An AIServices resource with project management is the current Microsoft Foundry resource.
resource foundry 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: foundryName
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    allowProjectManagement: true
    customSubDomainName: foundryName
    publicNetworkAccess: publicNetworkAccess
  }
  tags: tags
}

resource foundryProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  parent: foundry
  name: foundryProjectName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: foundryProjectDisplayName
    description: foundryProjectDescription
  }
  tags: tags
}

// Serialized after the project: the account rejects concurrent write operations.
resource llmDeployment 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  parent: foundry
  name: deploymentName
  sku: {
    name: deploymentSkuName
    capacity: deploymentCapacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: modelName
      version: modelVersion
    }
  }
  dependsOn: [
    foundryProject
  ]
}

output foundryEndpoint string = foundry.properties.endpoint
output foundryProjectName string = foundryProject.name
output llmDeploymentName string = llmDeployment.name
