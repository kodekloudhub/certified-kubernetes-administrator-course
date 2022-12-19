#!/bin/bash
echo cluster1 $(kubectl --context cluster1 top pods -A --no-headers | sort -nr -k3 | head -1) > /tmp/high_cpu_pod
echo cluster2 $(kubectl --context cluster2 top pods -A --no-headers | sort -nr -k3 | head -1) >> /tmp/high_cpu_pod
echo cluster3 $(kubectl --context cluster3 top pods -A --no-headers | sort -nr -k3 | head -1) >> /tmp/high_cpu_pod
echo cluster4 $(kubectl --context cluster4 top pods -A --no-headers | sort -nr -k3 | head -1) >> /tmp/high_cpu_pod
final_value=$(cat /tmp/high_cpu_pod | sort -nr -k 4 | awk '{print $1,$2,$3}' | head -1 | tr " " ,)
if [[ $(cat /opt/high_cpu_pod | grep $final_value) ]]
then 
        echo SUCCESS
else
        echo FAIL
fi
