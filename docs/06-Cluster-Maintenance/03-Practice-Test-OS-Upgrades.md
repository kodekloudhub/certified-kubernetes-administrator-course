# Practice Test - OS Upgrades
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816648)
  
Solutions to practice test - OS Upgrades
- Let us explore the environment first. How many nodes do you see in the cluster?
  
  <details>
  ```
  $ kubectl get nodes
  ```
  </details>
  
- How many applications do you see hosted on the cluster?
  
  <details>
  ```
  $ kubectl get deploy
  ```
  </details>
  
- Run the command 'kubectl get pods -o wide' and get the list of nodes the pods are placed on
  
  <details>
  ```
  $ kubectl get pods -o wide
  ```
  </details>
  
- Run the command kubectl drain node01 --ignore-daemonsets
  
  <details>
  ```
  $ kubectl drain node01 --ignore-daemonsets
  ```
  </details>
  
- Run the command 'kubectl get pods -o wide' and get the list of nodes the pods are placed on
  
  <details>
  ```
  $ kubectl get pods -o wide
  ```
  </details>
  
- Run the command kubectl uncordon node01
  
  <details>
  ```
  $ kubectl uncordon node01
  ```
  </details>
  
- Run the command kubectl get pods -o wide
  
  <details>
  ```
  $ kubectl get pods -o wide
  ```
  </details>
  
- Why are there no pods on node01?
  
  <details>
  ```
  Only when new pods are created they will be scheduled
  ```
  </details>
  
- Use the command kubectl describe node master and look under taint section to check if it has any taints.
  
  <details>
  ```
  $ kubectl describe node master
  ```
  </details>
  
- Run the command kubectl drain node02 --ignore-daemonsets
  
  <details>
  ```
  $ kubectl drain node02 --ignore-daemonsets
  ```
  </details>
  
- Check the applications hosted on the node02.
  
  <details>
  ```
  node02 has a pod not part of a replicaset
  $ kubectl get pods -o wide
  ```
  </details>
  
- Check the list of pods
  
  <details>
  ```
  $ kubectl get pods -o wide
  ```
  </details>
    
- What would happen to hr-app if node02 is drained forcefully?
  
  <details>
  ```
  $ kubectl drain node02 --ignore-daemonsets --force
  hr-app will be lost forever
  ```
  </details>
    
- Run the command kubectl drain node02 --ignore-daemonsets --force

  <details>
  ```
  $ kubectl drain node02 --ignore-daemonsets --force
  ```
  </details>
  
- Run the command kubectl cordon node03
  
  <details>
  ```
  $ kubectl cordon node03
  ```
  </details>

