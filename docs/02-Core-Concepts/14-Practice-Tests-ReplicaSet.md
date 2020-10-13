# Practice Test - ReplicaSets
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816569)
  
#### Solutions for the replicaset practice tests
1. Run the command **`kubectl get pods`** and count the number of pods.
   <details>

   ```
   $ kubectl get pods
   ```
   </details>

1. Run the command **`kubectl get replicaset`** and count the number of replicasets.
   
   <details>

   ```
   $ kubectl get rs
   ```
   </details>

1. Run the command **`kubectl get replicaset`**
   
   <details>

   ```
   $ kubectl get rs
   ```
   </details>

1. Run the command **`kubectl get replicaset`** and look at the count under the **`Desired`** column

   <details>

   ```
   $ kubectl get rs
   ```
   </details>

1. Run the command **`kubectl describe replicaset`** and look under the containers section.
   
   <details>

   ```
   $ kubectl describe replicaset (or)
   $ kubectl get rs -o wide
   ```
   </details>

1. Run the command **`kubectl get replicaset`** and look at the count under the **`Ready`** column

   <details>

   ```
   $ kubectl get repplicaset
   ```
   </details>

1. Run the command **`kubectl describe pods`** and look under the events section.
   
   <details>

   ```
   $ kubectl describe pods
   ```
   </details>

1. Run the command **`kubectl delete pod <podname>`**

   <details>

   ```
   $ kubectl delete pod new-replica-set-XXXX
   ```
   </details>

1. Run the command **`kubectl get pods`** and count the number of PODs
   
   <details>

   ```
   $ kubectl get pods
   ```
   </details>

1. ReplicaSets ensures that desired number of PODs always run

1. The value for **`apiVersion`** is incorrect. Find the correct apiVersion for ReplicaSet.

   Get the apiVersion for replicaset
   
   <details>

   ```
   $ kubectl explain replicaset|grep VERSION
   ```
   </details>

   Update the replicaset definition file with correct version and create a replicaset
    
   <details>

   ```
   $ kubectl create -f replicaset-definition-1.yaml
   ```
   </details>

1. The values for labels on lines 9 and 13 should match.
   <details>

   ```
   Selector matchLabels should match with POD labels - Update the replicaset-definition-2.yaml
   $ kubectl create -f replicaset-definition-2.yaml
   ```
   </details>

1. Run the command **`kubectl delete replicaset`**
   
   <details>

   ```
   $ kubectl delete replicaset replicaset-1
   $ kubectl delete rs replicaset-2
   ```
   </details>

1. Run the command **`kubectl edit replicaset new-replica-set`**, modify the image name to **`busybox`** and then save the file.
   
   <details>

   ```
   $ kubectl edit replicaset new-replica-set
   ```
   </details>

1. Run the command **`kubectl edit replicaset new-replica-set`**, modify the replicas and then save the file.
   
   <details>

   ```
   $ kubectl edit replicaset new-replica-set
   ```
   </details>

   Another way
   
   <details>
   
   ```
   $ kubectl scale --replicas=5 replicaset new-replica-set
   ```
   </details>

1. Run the command **`kubectl edit replicaset new-replica-set`**, modify the replicas and then save the file.

   <details>

   ```
   $ kubectl edit replicaset new-replica-set
   ```
   </details>

   Another way
   
   <details>

   ```
   $ kubectl scale --replicas=2 replicaset new-replica-set
   ```
   </details>

   
