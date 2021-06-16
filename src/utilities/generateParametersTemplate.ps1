# This script is generate an arm template parameters file template.

Param(
    [String] $filePath = "parameters.json"
)

$template = @'
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
    }
}
'@

New-Item $filePath -Value $template -Force