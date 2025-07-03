#!/usr/bin/env bash

set -eo pipefail

resource_group_name=$(env | grep -oP 'kml[A-Za-z0-9_-]+')

cat <<EOF
{
    "subscription_id": "$ACC_USER_SUBSCRIPTION",
    "resource_group_name": "$resource_group_name",
    "location": "$ACC_LOCATION"
}
EOF