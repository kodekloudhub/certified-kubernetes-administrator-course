# Practice Test - Taints and Tolerations
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-taints-and-tolerations/)
  
Solutions to the Practice Test - Taints and Tolerations

- Run the command 'kubectl get nodes' and count the number of nodes.
  
  <details>

  ```
  $ kubectl get nodes
  ```
  </details>

- Run the command 'kubectl describe node node01' and see the taint property

  <details>

  ```
  $ kubectl describe node node01
  ```
  </details>

- Run the command 'kubectl taint nodes node01 spray=mortein:NoSchedule'.

  <details>

  ```
  $ kubectl taint nodes node01 spray=mortein:NoSchedule
  ```
  </details>

- Answer file at /var/answers/mosquito.yaml

  <details>

  ```
  master $ cat /var/answers/mosquito.yaml
  apiVersion: v1
  kind: Pod
   metadata:
    name: mosquito
  spec:
   containers:
   - image: nginx
     name: mosquito
  ```
  ```
  $ kubectl create -f /var/answers/mosquito.yaml
  ```
  </details>

- Run the command 'kubectl get pods' and see the state

  <details>

  ```
  $ kubectl get pods
  ```
  </details>

- Why do you think the pod is in a pending state?

  <details>

  ```
  POD Mosquito cannot tolerate taint Mortein
  ```
  </details>

- Answer file at /var/answers/bee.yaml

  <details>

  ```
  master $ cat /var/answers/bee.yaml
  apiVersion: v1
  kind: Pod
  metadata:
   name: bee
  spec:
   containers:
   - image: nginx
     name: bee
   tolerations:
   - key: spray
     value: mortein
     effect: NoSchedule
     operator: Equal
  ```
  ```
  $ kubectl create -f /var/answers/bee.yaml
  ```
  </details>

- Notice the 'bee' pod was scheduled on node node01 despite the taint.

- Run the command 'kubectl describe node master' and see the taint property
  
  <details>

  ```
  $ kubectl describe node master
  ```
  </details>

- Run the command 'kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-'.
  
  <details>

  ```
  $ kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-
  ```
  </details>

- Run the command 'kubectl get pods' and see the state

  <details>

  ```
  $ kubectl get pods
  ```
  </details>

- Run the command 'kubectl get pods -o wide' and look at the Node column
 
  <details>

  ```
  $ kubectl get pods -o wide
  ```
  </details>


