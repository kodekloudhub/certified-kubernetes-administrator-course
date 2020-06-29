# Practice Test - ReplicaSets
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816569)
  
#### Solutions for the replicaset practice tests
1. Run the command **`kubectl get pods`** and count the number of pods.
   ```
   $ kubectl get pods
   ```
1. Run the command **`kubectl get replicaset`** and count the number of replicasets.
   ```
   $ kubectl get rs
   ```
1. Run the command **`kubectl get replicaset`**
   ```
   $ kubectl get rs
   ```
1. Run the command **`kubectl get replicaset`** and look at the count under the **`Desired`** column
   ```
   $ kubectl get rs
   ```
1. Run the command **`kubectl describe replicaset`** and look under the containers section.
   ```
   $ kubectl describe replicaset (or)
   $ kubectl get rs -o wide
   ```
1. Run the command **`kubectl get replicaset`** and look at the count under the **`Ready`** column
   ```
   $ kubectl get repplicaset
   ```
1. Run the command **`kubectl describe pods`** and look under the events section.
   ```
   $ kubectl describe pods
   ```
1. Run the command **`kubectl delete pod <podname>`**
   ```
   $ kubectl delete pod new-replica-set-XXXX
   ```
1. Run the command **`kubectl get pods`** and count the number of PODs
   ```
   $ kubectl get pods
   ```
1. ReplicaSets ensures that desired number of PODs always run

1. The value for **`apiVersion`** is incorrect. Find the correct apiVersion for ReplicaSet.

   Get the apiVersion for replicaset
   ```
   $ kubectl explain replicaset|grep VERSION
   ```
   Update the replicaset defination file with correct version and create a replicaset
   ```
   $ kubectl create -f replicaset-defination-1.yaml
   ```
1. The values for labels on lines 9 and 13 should match.
   ```
   Selector matchLabels should match with POD labels - Update the replicaset-defination-2.yaml
   $ kubectl create -f replicaset-defination-2.yaml
   ```
1. Run the command **`kubectl delete replicaset`**
   ```
   $ kubectl delete replicaset replicaset-1
   $ kubectl delete rs replicaset-2
   ```
1. Run the command **`kubectl edit replicaset new-replica-set`**, modify the image name to **`busybox`** and then save the file.
   ```
   $ kubectl edit replicaset new-replica-set
   ```
1. Run the command *8`kubectl edit replicaset new-replica-set`**, modify the replicas and then save the file.
   ```
   $ kubectl edit replicaset new-replica-set
   ```
   Another way
   ```
   $ kubectl scale --replicas=5 replicaset new-replica-set
   ```
1. Run the command **`kubectl edit replicaset new-replica-set`**, modify the replicas and then save the file.
   ```
   $ kubectl edit replicaset new-replica-set
   ```
   Another way
   ```
   $ kubectl scale --replicas=2 replicaset new-replica-set
   ```
   
