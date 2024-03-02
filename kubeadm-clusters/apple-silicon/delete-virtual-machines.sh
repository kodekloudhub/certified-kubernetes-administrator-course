#!/usr/bin/env bash

set -eo pipefail

NUM_WORKER_NODES=2
MEM_GB=$(( $(sysctl hw.memsize | cut -d ' ' -f 2) /  1073741824 ))

[ $MEM_GB -lt 16 ] && NUM_WORKER_NODES=1

workers=$(for n in $(seq 1 $NUM_WORKER_NODES) ; do echo -n "node0$n " ; done)

for n in $workers controlplane
do
    multipass stop $n
    multipass delete $n
done

multipass purge

echo
echo "You should now remove all the following lines from /var/db/dhcpd_leases"
echo
cat /var/db/dhcpd_leases | egrep -A 5 -B 1 '(controlplane|node01|node02)'
echo
cat <<EOF
Use the following command to do this

  sudo vi /var/db/dhcpd_leases

EOF
