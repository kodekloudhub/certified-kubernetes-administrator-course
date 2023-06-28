#!/usr/bin/env bash
# When VMs are deleted, IPs remain allocated in dhcpdb
# IP reclaim: https://discourse.ubuntu.com/t/is-it-possible-to-either-specify-an-ip-address-on-launch-or-reset-the-next-ip-address-to-be-used/30316

ARG=$1

set -euo pipefail

RED="\e[1;31m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
BLUE="\e[1;34m"
NC="\e[0m"

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

workers=$(for n in $(seq 1 $NUM_WORKER_NODES) ; do echo -n "kubeworker0$n " ; done)
# workers=''

# If the nodes are running, reset them
if multipass list --format json | jq -r '.list[].name' | egrep 'kube(master|node01|node02)' > /dev/null
then
    echo -n -e $RED
    read -p "VMs are running. Delete and rebuild them (y/n)? " ans
    echo -n -e $NC
    [ "$ans" != 'y' ] && exit 1
fi

# Boot the nodes
for node in kubemaster $workers
do
    if multipass list --format json | jq -r '.list[].name' | grep "$node"
    then
        echo -e "${YELLOW}Deleting $node${NC}"
        multipass delete $node
        multipass purge
    fi

    echo -e "${BLUE}Launching ${node}${NC}"
    multipass launch --disk 5G --memory $VM_MEM_GB --cpus 2 --name $node jammy
    echo -e "${GREEN}$node booted!${NC}"
done

# Create hostfile entries 
echo -e "${BLUE}Setting hostnames${NC}"
hostentries=/tmp/hostentries

[ -f $hostentries ] && rm -f $hostentries

for node in kubemaster $workers
do
    ip=$(multipass info $node --format json | jq -r 'first( .info[] | .ipv4[0] )')
    echo "$ip $node" >> $hostentries
done

for node in kubemaster $workers
do
    multipass transfer $hostentries $node:/tmp/
    multipass transfer $SCRIPT_DIR/01-setup-hosts.sh $node:/tmp/
    multipass exec $node -- /tmp/01-setup-hosts.sh
done
echo -e "${GREEN}Done!${NC}"

if [ "$ARG" = "-auto" ] 
then
    # Set up hosts
    echo -e "${BLUE}Setting up common componenets${NC}"
    join_command=/tmp/join-command.sh

    for node in kubemaster $workers
    do
        echo -e "${BLUE}- ${node}${NC}"
        multipass transfer $hostentries $node:/tmp/
        multipass transfer $SCRIPT_DIR/*.sh $node:/tmp/ 
        for script in 02-setup-kernel.sh 03-setup-cri.sh 04-kube-components.sh
        do
            multipass exec $node -- /tmp/$script
        done
    done

    echo -e "${GREEN}Done!${NC}"

    # Configure control plane
    echo -e "${BLUE}Setting up control plane${NC}"
    multipass exec kubemaster /tmp/05-deploy-controlplane.sh
    multipass transfer kubemaster:/tmp/join-command.sh $join_command
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