#!/usr/bin/env bash
# When VMs are deleted, IPs remain allocated in dhcpdb
# IP reclaim: https://discourse.ubuntu.com/t/is-it-possible-to-either-specify-an-ip-address-on-launch-or-reset-the-next-ip-address-to-be-used/30316

ARG=$1

set -euo pipefail

# Set the build mode
# "BRIDGE" - Places VMs on your local network so cluster can be accessed from browser.
#            You must have enough spare IPs on your network for the cluster nodes.
# "NAT"    - Places VMs in a private virtual network. Cluster cannot be accessed
#            without setting up a port forwarding rule for every NodePort exposed.
#            Use this mode if for some reason BRIDGE doesn't work for you.
BUILD_MODE="BRIDGE"


RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
NC="\033[0m"

if ! command -v jq > /dev/null
then
    echo -e "${RED}'jq' not found. Please install it${NC}"
    echo "https://github.com/stedolan/jq/wiki/Installation#macos"
    exit 1
fi

if ! command -v multipass > /dev/null
then
    echo -e "${RED}'multipass' not found. Please install it${NC}"
    echo "https://multipass.run/install"
    exit 1
fi

NUM_WORKER_NODES=2
MEM_GB=$(( $(sysctl hw.memsize | cut -d ' ' -f 2) /  1073741824 ))
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/scripts
VM_MEM_GB=3G

if [ $MEM_GB -lt 8 ]
then
    echo -e "${RED}System RAM is ${MEM_GB}GB. This is insufficient to deploy a working cluster.${NC}"
    exit 1
fi

if [ $MEM_GB -lt 16 ]
then
    echo -e "${YELLOW}System RAM is ${MEM_GB}GB. Deploying only one worker node.${NC}"
    NUM_WORKER_NODES=1
    VM_MEM_GB=2G
    sleep 1
fi

workers=$(for n in $(seq 1 $NUM_WORKER_NODES) ; do echo -n "node0$n " ; done)

# Determine interface for bridge
interface=""
bridge_arg="--bridged"

for iface in $(multipass networks --format json | jq -r '.list[] | .name')
do
    if netstat -rn -f inet | grep "^default.*${iface}" > /dev/null
    then
        interface=$iface
        break
    fi
done

if [ "$(multipass get local.bridged-network)" = "<empty>" ]
then
    echo -e "${BLUE}Configuring bridge network...${NC}"

    if [ -z "${interface}" ]
    then
        echo -e "${YELLOW}No suitable interface detected to use as bridge"
        echo "Falling back to NAT installation"
        echo -e "You will not be able to use your browser to connect to NodePort services.${NC}"
        BUILD_MODE="NAT"
        bridge_arg=""
    else
        # Set the bridge
        echo -e "${GREEN}Configuring bridge to interface '$(multipass networks | grep ${interface})'${NC}"
        multipass set local.bridged-network=${interface}
    fi
fi

# If the nodes are running, reset them
if multipass list --format json | jq -r '.list[].name' | egrep '(controlplane|node01|node02)' > /dev/null
then
    echo -n -e $RED
    read -p "VMs are running. Delete and rebuild them (y/n)? " ans
    echo -n -e $NC
    [ "$ans" != 'y' ] && exit 1
fi

# Boot the nodes
for node in controlplane $workers
do
    if multipass list --format json | jq -r '.list[].name' | grep "$node"
    then
        echo -e "${YELLOW}Deleting $node${NC}"
        multipass delete $node
        multipass purge
    fi


    echo -e "${BLUE}Launching ${node}${NC}"
    if ! multipass launch $bridge_arg --disk 5G --memory $VM_MEM_GB --cpus 2 --name $node jammy 2>/dev/null
    then
        # Did it actually launch?
        sleep 1
        if [ "$(multipass list --format json | jq -r --arg no $node '.list[] | select (.name == $no) | .state')" != "Running" ]
        then
            echo -e "${RED}$node failed to start!${NC}"
            exit 1
        fi
    fi
    echo -e "${GREEN}$node booted!${NC}"
done

# Create hostfile entries
echo -e "${BLUE}Setting hostnames${NC}"
hostentries=/tmp/hostentries
set -x
network=$(netstat -rn -f inet | grep "^default.*${interface}" | awk '{print $2}' | awk 'BEGIN { FS="." } { printf "%s.%s.%s", $1, $2, $3 }')
[ -f $hostentries ] && rm -f $hostentries

for node in controlplane $workers
do
    if [ "$BUILD_MODE" = "BRIDGE" ]
    then
        ip=$(multipass info $node --format json | jq -r --arg nw $network 'first( .info[] )| .ipv4  | .[] | select(startswith($nw))')
    else
        ip=$(multipass info $node --format json | jq -r 'first( .info[] | .ipv4[0] )')
    fi
    echo "$ip $node" >> $hostentries
done

for node in controlplane $workers
do
    multipass transfer $hostentries $node:/tmp/
    multipass transfer $SCRIPT_DIR/01-setup-hosts.sh $node:/tmp/
    multipass exec $node -- /tmp/01-setup-hosts.sh $BUILD_MODE $network
done

echo -e "${GREEN}Done!${NC}"

if [ "$ARG" = "-auto" ]
then
    # Set up hosts
    echo -e "${BLUE}Setting up common components${NC}"
    join_command=/tmp/join-command.sh

    for node in controlplane $workers
    do
        echo -e "${BLUE}- ${node}${NC}"
        multipass transfer $hostentries $node:/tmp/
        multipass transfer $SCRIPT_DIR/*.sh $node:/tmp/
        for script in 02-setup-kernel.sh 03-setup-nodes.sh 04-kube-components.sh
        do
            multipass exec $node -- /tmp/$script
        done
    done

    echo -e "${GREEN}Done!${NC}"

    # Configure control plane
    echo -e "${BLUE}Setting up control plane${NC}"
    multipass exec controlplane /tmp/05-deploy-controlplane.sh
    multipass transfer controlplane:/tmp/join-command.sh $join_command
    echo -e "${GREEN}Done!${NC}"

    # Configure workers
    for n in $workers
    do
        echo -e "${BLUE}Setting up ${n}${NC}"
        multipass transfer $join_command $n:/tmp
        multipass exec $n -- sudo $join_command
        echo -e "${GREEN}Done!${NC}"
    done
fi