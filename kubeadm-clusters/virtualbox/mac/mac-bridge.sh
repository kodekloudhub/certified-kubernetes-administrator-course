#!/bin/bash

iface=$(netstat -rn -f inet | grep '^default' | sort | head -1 | awk '{print $4}')
interface=$(VBoxManage list bridgedifs | awk '/^Name:/ { print }' | sed -e 's/^Name:[ ]*\(.*\)/\1/' | grep $iface)
echo -n $interface