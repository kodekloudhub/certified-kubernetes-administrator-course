#!/bin/bash
echo cluster1 $(kubectl --context cluster1 top node --no-headers | sort -nr -k4 | head -1) > /tmp/high_memory_node
echo cluster2 $(kubectl --context cluster2 top node --no-headers | sort -nr -k4 | head -1) >> /tmp/high_memory_node
echo cluster3 $(kubectl --context cluster3 top node --no-headers | sort -nr -k4 | head -1) >> /tmp/high_memory_node
echo cluster4 $(kubectl --context cluster4 top node --no-headers | sort -nr -k4 | head -1) >> /tmp/high_memory_node
final_value=$(cat /tmp/high_memory_node | sort -nr -k 5 | awk '{print $1,$2}' | head -1 | tr " " ,)
if [[ $(cat /opt/high_memory_node | grep $final_value) ]]
then 
        echo SUCCESS
else
        echo FAIL
fi
