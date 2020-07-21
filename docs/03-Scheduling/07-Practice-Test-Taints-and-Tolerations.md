# Practice Test Taints and Tolerations
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/10277990)
  
Solutions to the Practice Test - Taints and Tolerations

- Run the command 'kubectl get nodes' and count the number of nodes.
  ```
  $ kubectl get nodes
  ```
- Run the command 'kubectl describe node node01' and see the taint property
  ```
  $ kubectl describe node node01
  ```
- Run the command 'kubectl taint nodes node01 spray=mortein:NoSchedule'.
  ```
  $ kubectl taint nodes node01 spray=mortein:NoSchedule
  ```
- Answer file at /var/answers/mosquito.yaml
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
- Run the command 'kubectl get pods' and see the state
  ```
  $ kubectl get pods
  ```
- Why do you think the pod is in a pending state?
  ```
  POD Mosquito cannot tolerate taint Mortein
  ```
- Answer file at /var/answers/bee.yaml
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
- Notice the 'bee' pod was scheduled on node node01 despite the taint.

- Run the command 'kubectl describe node master' and see the taint property
  ```
  $ kubectl describe node master
  ```
- Run the command 'kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-'.
  ```
  $ kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-
  ```
- Run the command 'kubectl get pods' and see the state
  ```
  $ kubectl get pods
  ```
- Run the command 'kubectl get pods -o wide' and look at the Node column
  ```
  $ kubectl get pods -o wide
  ```

