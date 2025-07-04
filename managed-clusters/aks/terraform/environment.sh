#!/usr/bin/env bash
#
# This script is executed by terraform as 'data "external" "environment"'
# to retrieve information we need from the cloudshell environment
# in order to configure the cluster.

set -eo pipefail

resource_group_name=$(env | grep -oP 'kml[A-Za-z0-9_-]+')

cat <<EOF
{
    "subscription_id": "$ACC_USER_SUBSCRIPTION",
    "resource_group_name": "$resource_group_name",
    "location": "$ACC_LOCATION"
}
EOF