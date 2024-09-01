#!/usr/bin/env bash

PACKAGES=$1

if [ -z "$PACKAGES" ]
then
    exit 0
fi

# DISTRO will be "debian" or "rhel"
DISTRO=$(. /etc/os-release ; echo $ID_LIKE | cut -d ' ' -f 1)

case $DISTRO in

    debian)
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        echo $PACKAGES | tr ',' '\n' | xargs apt-get install -y
        ;;
    rhel)
        echo $PACKAGES | tr ',' '\n' | xargs yum install -y
        ;;
esac
