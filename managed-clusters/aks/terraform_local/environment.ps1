# Login to Azure using Service Principal
az login --service-principal `
  -u $env:ARM_CLIENT_ID `
  -p $env:ARM_CLIENT_SECRET `
  --tenant $env:ARM_TENANT_ID > $null 2>&1

# Get subscription ID
$subscriptionId = az account show --query id -o tsv

# Get first resource group starting with "kml"
$rgName = az group list --query "[?starts_with(name, 'kml')].name | [0]" -o tsv

# Get location of that resource group
$location = az group show --name $rgName --query location -o tsv

# Output in JSON format
$result = @{
    subscription_id     = $subscriptionId
    location            = $location
    resource_group_name = $rgName
}

# Convert to JSON and print
$result | ConvertTo-Json -Compress
