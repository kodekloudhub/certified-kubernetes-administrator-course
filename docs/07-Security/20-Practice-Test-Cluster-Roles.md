# Practice Test - Cluster Roles
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816671)
 
Solutions to practice test - cluster roles
- Run the command kubectl get clusterroles --no-headers | wc -l or kubectl get clusterroles --no-headers -o json | jq '.items | length'
  
  <details>
  
  ```
  $ kubectl get clusterroles --no-headers | wc -l (or)
  $ kubectl get clusterroles --no-headers -o json | jq '.items | length'
  ```
  
  </details>
  
- Run the command kubectl get clusterrolebindings --no-headers | wc -l or kubectl get clusterrolebindings --no-headers -o json | jq '.items | length'

  <details>
  
  ```
  $ kubectl get clusterrolebindings --no-headers | wc -l (or)
  $ kubectl get clusterrolebindings --no-headers -o json | jq '.items | length'
  ```
  
  </details>
  
- What namespace is the cluster-admin clusterrole part of?

  <details>
  
  ```
  $ Cluster roles are cluster wide and not part of any namespace
  ```
  
  </details>
  
- Run the command kubectl describe clusterrolebinding cluster-admin
  
  <details>
  
  ```
  $ kubectl describe clusterrolebinding cluster-admin
  ```
  
  </details>
  
- Run the command kubectl describe clusterrole cluster-admin

  <details>
  
  ```
  $ kubectl describe clusterrole cluster-admin
  ```
  
  </details>
  
- Check answer at /var/answers

  <details>
  
  ```
  $ kubectl create -f /var/answers/michelle-node-admin.yaml
  ```
  
  </details>
  
- Check answer at /var/answers

  <details>
  
  ```
  $ kubectl create -f /var/answers/michelle-storage-admin.yaml
  ```
  
  </details>
  
  




