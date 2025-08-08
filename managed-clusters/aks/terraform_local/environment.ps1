# Login to Azure using Service Principal

$null = az login --service-principal `
    --username $env:TF_VAR_ARM_CLIENT_ID `
    --password $env:TF_VAR_ARM_CLIENT_SECRET `
    --tenant $env:TF_VAR_ARM_TENANT_ID

# Get first resource group starting with "kml"
$rgName = az group list --query "[?starts_with(name, 'kml')].name | [0]" -o tsv

# Get location of that resource group
$location = az group show --name $rgName --query location -o tsv

# Output in JSON format
$result = @{
    location            = $location
    resource_group_name = $rgName
}

# Convert to JSON and print
$result | ConvertTo-Json -Compress
