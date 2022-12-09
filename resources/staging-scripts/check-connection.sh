#!/bin/bash
if [[  $(ssh $1 kubectl exec $2 -- nc -w 2  $3 $4) ]];
  then 
  echo success;
else 
  echo fail;
fi
