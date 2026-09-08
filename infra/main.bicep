targetScope = 'subscription'

@description('Name of the resource group that will contain the Azure AI Foundry resource.')
param resourceGroupName string

@description('Azure region in which to deploy the Azure AI Foundry resource and model.')
param location string

@description('Globally unique name for the Microsoft Foundry resource.')
@minLength(2)
@maxLength(64)
param foundryName string

@description('Name of the Microsoft Foundry project.')
@minLength(3)
@maxLength(64)
param foundryProjectName string

@description('Display name for the Microsoft Foundry project.')
param foundryProjectDisplayName string = foundryProjectName

@description('Description displayed for the Microsoft Foundry project.')
param foundryProjectDescription string = 'Hackathon Microsoft Foundry project.'

@description('Name exposed to applications for the LLM deployment.')
param deploymentName string = 'chat'

@description('Model name available in the selected Azure region.')
param modelName string = 'gpt-4o-mini'

@description('Model version available in the selected Azure region.')
param modelVersion string = '2026-03-17'

@description('Deployment SKU for the selected model.')
param deploymentSkuName string = 'GlobalStandard'

@description('Model deployment capacity in thousands of tokens per minute.')
@minValue(1)
param deploymentCapacity int = 1

@description('Whether the Foundry endpoint accepts public network traffic.')
param publicNetworkAccess string = 'Enabled'

@description('Tags applied to all supported resources.')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module foundry './foundry.bicep' = {
  name: 'foundry-${deploymentName}'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    foundryName: foundryName
    foundryProjectName: foundryProjectName
    foundryProjectDisplayName: foundryProjectDisplayName
    foundryProjectDescription: foundryProjectDescription
    deploymentName: deploymentName
    modelName: modelName
    modelVersion: modelVersion
    deploymentSkuName: deploymentSkuName
    deploymentCapacity: deploymentCapacity
    publicNetworkAccess: publicNetworkAccess
    tags: tags
  }
  dependsOn: [
    resourceGroup
  ]
}

output foundryEndpoint string = foundry.outputs.foundryEndpoint
output foundryProjectName string = foundry.outputs.foundryProjectName
output llmDeploymentName string = foundry.outputs.llmDeploymentName
output deployedResourceGroupName string = resourceGroup.name
