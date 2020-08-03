# Practice Test - OS Upgrades
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816648)
  
Solutions to practice test - OS Upgrades
- Let us explore the environment first. How many nodes do you see in the cluster?
  ```
  $ kubectl get nodes
  ```
- How many applications do you see hosted on the cluster?
  ```
  $ kubectl get deploy
  ```
- Run the command 'kubectl get pods -o wide' and get the list of nodes the pods are placed on
  ```
  $ kubectl get pods -o wide
  ```
- Run the command kubectl drain node01 --ignore-daemonsets
  ```
  $ kubectl drain node01 --ignore-daemonsets
  ```
- Run the command 'kubectl get pods -o wide' and get the list of nodes the pods are placed on
  ```
  $ kubectl get pods -o wide
  ```
- Run the command kubectl uncordon node01
  ```
  $ kubectl uncordon node01
  ```
- Run the command kubectl get pods -o wide
  ```
  $ kubectl get pods -o wide
  ```
- Why are there no pods on node01?
  ```
  Only when new pods are created they will be scheduled
  ```
- Use the command kubectl describe node master and look under taint section to check if it has any taints.
  ```
  $ kubectl describe node master
  ```
- Run the command kubectl drain node02 --ignore-daemonsets
  ```
  $ kubectl drain node02 --ignore-daemonsets
  ```
- Check the applications hosted on the node02.
  ```
  node02 has a pod not part of a replicaset
  
  $ kubectl get pods -o wide
  ```
- Check the list of pods
  ```
  $ kubectl get pods -o wide
  ```
- What would happen to hr-app if node02 is drained forcefully?
  ```
  $ kubectl drain node02 --ignore-daemonsets --force
  
  hr-app will be lost forever
  ```
- Run the command kubectl drain node02 --ignore-daemonsets --force
  ```
  $ kubectl drain node02 --ignore-daemonsets --force
  ```
- Run the command kubectl cordon node03
  ```
  $ kubectl cordon node03
  ```

