$resourceGroupName = 'rg-lab'

az deployment group create `
--resource-group $resourceGroupName `
-f main.bicep