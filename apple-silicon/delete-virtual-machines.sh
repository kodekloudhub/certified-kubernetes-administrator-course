#!/usr/bin/env bash

set -eo pipefail

NUM_WORKER_NODES=1

workers=$(for n in $(seq 1 $NUM_WORKER_NODES) ; do echo -n "kubeworker0$n " ; done)

for n in $workers kubemaster
do
    multipass stop $n
    multipass delete $n
done

multipass purge


