# Practice Test - Cluster Roles
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816671)
 
Solutions to practice test - cluster roles
- Run the command kubectl get clusterroles --no-headers | wc -l or kubectl get clusterroles --no-headers -o json | jq '.items | length'
  ```
  $ kubectl get clusterroles --no-headers | wc -l (or)
  $ kubectl get clusterroles --no-headers -o json | jq '.items | length'
  ```
- Run the command kubectl get clusterrolebindings --no-headers | wc -l or kubectl get clusterrolebindings --no-headers -o json | jq '.items | length'
  ```
  $ kubectl get clusterrolebindings --no-headers | wc -l (or)
  $ kubectl get clusterrolebindings --no-headers -o json | jq '.items | length'
  ```
- What namespace is the cluster-admin clusterrole part of?
  ```
  $ Cluster roles are cluster wide and not part of any namespace
  ```
- Run the command kubectl describe clusterrolebinding cluster-admin
  ```
  $ kubectl describe clusterrolebinding cluster-admin
  ```
- Run the command kubectl describe clusterrole cluster-admin
  ```
  $ kubectl describe clusterrole cluster-admin
  ```
- Check answer at /var/answers
  ```
  $ kubectl create -f /var/answers/michelle-node-admin.yaml
  ```
- Check answer at /var/answers
  ```
  $ kubectl create -f /var/answers/michelle-storage-admin.yaml
  ```
  




