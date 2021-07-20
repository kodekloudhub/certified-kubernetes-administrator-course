# Practice Test - Node Affinity
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-node-affinity-2/)
  
Solutions to practice test - node affinity

- Run the command 'kubectl describe node node01' and count the number of labels under **`Labels Section`**.
  
  <details>

  ```
  $ kubectl describe node node01
  ```
  </details>

- Run the command 'kubectl describe node node01' and see the label section
  
  <details>

  ```
  $ kubectl describe node node01
  ```
  </details>

- Run the command 'kubectl label node node01 color=blue'.

  <details>

  ```
  $ kubectl label node node01 color=blue
  ```
  </details>

- Run the below commands

  <details>

  ```
  $ kubectl create deployment blue --image=nginx
  $ kubectl scale deployment blue --replicas=6
  ```
  </details>

- Check if master and node01 have any taints on them that will prevent the pods to be scheduled on them. If there are no taints, the pods can be scheduled on either node.
  
  <details>

  ```
  $ kubectl describe nodes|grep -i taints
  $ kubectl get pods -o wide
  ```
  </details>

- Answer file at /var/answers/blue-deployment.yaml
  
  <details>

  ```
  $ kubectl edit deployment blue
  ```
  </details>

  Add the below under the template.spec section
  
  <details>

  ```
  affinity:
      nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue
   ```
   </details>

 - Run the command 'kubectl get pods -o wide' and see the Node column
   
   <details>

   ```
   $ kubectl get pods -o wide
   ```
   </details>

 - Answer file at /var/answers/red-deployment.yaml
   Add the below under the template.spec section
   
   <details>

   ```
   affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists
   ```
   ```
   $ kubectl create -f red-deployment.yaml
   ```
   ```
   $ kubectl get pods -o wide
   ```
   </details>
   
  
  
