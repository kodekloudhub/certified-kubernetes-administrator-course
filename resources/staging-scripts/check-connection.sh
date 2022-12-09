#!/bin/bash
if [[  ! $(ssh $1 kubectl exec $2 -- nc -w 2  $3 80) ]];
  then 
  echo success;
else 
  echo fail;
fi
