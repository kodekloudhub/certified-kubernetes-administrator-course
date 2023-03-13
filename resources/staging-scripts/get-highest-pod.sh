#!/bin/bash

get_highest_pod() {
    local highest=0
    local highest_pod=""
    local highest_cluster=""
    local metric_key=""
    
    if [[ "$1" == "cpu" ]]; then
        metric_key="3"
    elif [[ "$1" == "memory" ]]; then
        metric_key="4"
    else
        echo "Invalid argument. Usage: $0 [cpu|memory]"
        return 1
    fi
    
    for cluster in cluster1 cluster2 cluster3 cluster4; 
    do 
        pod_info=$(kubectl top pods -A --context $cluster --no-headers | sort -nr -k${metric_key} | head -1 | awk '{print $1","$2","$'$metric_key'}')
        current_metric=$(echo $pod_info | awk -F',' '{print $3}' | sed 's/m//' | sed 's/Mi//')
        if (( $(echo "$current_metric $highest" | awk '{if ($1 > $2) print 1; else print 0}') )); then
            highest=$current_metric
            highest_pod=$pod_info
            highest_cluster=$cluster
        fi
    done
    
    highest_pod=${highest_pod%,*} # Remove everything after the last comma
    echo $highest_cluster,$highest_pod
}

get_highest_pod $@
