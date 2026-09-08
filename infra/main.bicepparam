using './main.bicep'

param resourceGroupName = 'rg-hackathon-rbs2026-dev'
param location = 'swedencentral'
param foundryName = 'foundry-hackathon-rbs2026-dev'
param foundryProjectName = 'rbs2026-dev'
param foundryProjectDisplayName = 'RBS 2026 Hackathon Dev'
param foundryProjectDescription = 'Microsoft Foundry project for the RBS 2026 hackathon.'

// Select a model and version available in the selected Azure region.
param deploymentName = 'gpt-5.4-mini'
param modelName = 'gpt-5.4-mini'
param modelVersion = '2026-03-17'
param deploymentSkuName = 'GlobalStandard'
param deploymentCapacity = 1

param tags = {
  environment: 'dev'
  project: 'hackathon-rbs2026'
}
