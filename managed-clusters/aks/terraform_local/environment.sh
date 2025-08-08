#!/bin/bash

# Login to Azure using Service Principal
az login --service-principal \
    --username $TF_VAR_ARM_CLIENT_ID \
    --password $TF_VAR_ARM_CLIENT_SECRET \
    --tenant $TF_VAR_ARM_TENANT_ID > /dev/null 2>&1

# Get resource group starting with "kml"
RG_NAME=$(az group list --query "[?starts_with(name, 'kml')].name | [0]" -o tsv)

# Get location of that resource group
LOCATION=$(az group show --name "$RG_NAME" --query location -o tsv)

# Output in JSON format for Terraform
echo "{
  \"location\": \"$LOCATION\",
  \"resource_group_name\": \"$RG_NAME\"
}"