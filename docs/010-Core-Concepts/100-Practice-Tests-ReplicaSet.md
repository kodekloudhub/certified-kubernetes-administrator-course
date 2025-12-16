# Practice Test - ReplicaSets
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-replicasets/)

#### Solutions for the replicaset practice tests
1. <details>
   <summary>How many pods exist on the system?</summary>

   ```bash
   kubectl get pods
   ```

   Count the number of pods (if any)

   </details>

1. <details>
   <summary>How many ReplicaSets exist on the system?</summary>

   ```bash
   kubectl get replicasets
   ```

   Count the number of ReplicaSets  (if any)

   </details>


1. <details>
   <summary>How about now? How many ReplicaSets do you see?</summary>

   ```bash
   kubectl get replicasets
   ```

   Count the number of ReplicaSets  (if any)

   </details>

1. <details>
   <summary>How many PODs are DESIRED in the new-replica-set?</summary>

   From the output of Q3, look in `DESIRED` column
   </details>

1. <details>
   <summary>What is the image used to create the pods in the new-replica-set?</summary>

   ```
   kubectl describe replicaset
   ```

   ...and look under the containers section --- or --

   ```
   kubectl get rs -o wide
   ```

   ...and look in the `IMAGES` column. Kubernetes accepts `rs` as shorthand for `replicaset`.

   </details>

1. <details>
   <summary>How many PODs are READY in the new-replica-set?</summary>

   ```
   kubectl get rs
   ```

   Look in the `READY` column.
   </details>

1. <details>
   <summary>Why do you think the PODs are not ready?</summary>

   ```
   kubectl describe pods
   ```

   Look in the `Events` section at the end.
   </details>

1. <details>
   <summary>Delete any one of the 4 PODs.</summary>

   ```
   kubectl get pods
   ```

   Choose any of the four.

   ```
   kubectl delete pod new-replica-set-XXXX
   ```
   </details>

1. <details>
   <summary>How many PODs exist now?</summary>

   ```
   kubectl get pods
   ```

   </details>

1. <details>
   <summary>Why are there still 4 PODs, even after you deleted one?</summary>
   > ReplicaSets ensures that desired number of PODs always run

   </details>

1. <details>
   <summary>Create a ReplicaSet using the replicaset-definition-1.yaml file located at /root/.</br>There is an issue with the file, so try to fix it.</summary>

   ```
   kubectl create -f replicaset-definition-1.yaml
   ```

   Note the error message.

   Get the apiVersion for replicaset

   ```
   $ kubectl explain replicaset | grep VERSION
   ```

   Update the replicaset definition file in `vi` with correct version and then retry creation.

   ```
   $ kubectl create -f replicaset-definition-1.yaml
   ```
   </details>

1. <details>
   <summary>Fix the issue in the replicaset-definition-2.yaml file and create a ReplicaSet using it.</summary>

   ```
   kubectl create -f replicaset-definition-1.yaml
   ```

   Note the error message.

   Selector matchLabels should match with POD labels - Update `replicaset-definition-2.yaml`

   The values for labels on lines 9 and 13 should match.

   ```
   $ kubectl create -f replicaset-definition-2.yaml
   ```
   </details>

1. <details>
   <summary>Delete the two newly created ReplicaSets - replicaset-1 and replicaset-2</summary>

   ```
   kubectl delete replicaset replicaset-1
   kubectl delete rs replicaset-2
   ```

   --- OR ---

   ```
   kubectl delete replicaset replicaset-1 replicaset-2
   ```

   </details>

1. <details>
   <summary>Fix the original replica set new-replica-set to use the correct busybox image.</summary>

   ```
   kubectl edit replicaset new-replica-set
   ```

   Edit the image to be `busybox`, save and exit.
   </details>

1. <details>
   <summary>Fix the original replica set new-replica-set to use the correct busybox image.</summary>

   ```
   kubectl edit replicaset new-replica-set
   ```

   Fix the image, save and exit.

   You will note if you do `kubectl get pods`, that they are still broken. ReplicaSets are not very smart and do not redeploy pods when the container specification has been edited.

   We must either delete and recreate the replicaset by exporting its YAML...

   ```
   kubectl get rs new-replica-set -o yaml > rs.yaml
   kubectl delete rs new-replica-set
   kunectl create -f rs.yaml
   ```

   -- OR --

   Delete each broken pod. The ReplicaSet will deploy a new one in its place which should be working.

   -- OR --

   Scale it to zero, then back to 4
   ```
   kubectl scale rs new-replica-set --replicas 0
   kubectl scale rs new-replica-set --replicas 4
   ```

   </details>

1. <details>
   <summary>Scale the ReplicaSet to 5 PODs.</summary>

   ```
   kubectl scale rs new-replica-set --replicas 5
   ```

   </details>


