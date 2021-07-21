# Practice Test - RBAC
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-role-based-access-controls/)

Solutions to practice test - RBAC
- Run the command kubectl describe pod kube-apiserver-master -n kube-system and look for --authorization-mode
  
  <details>
  
  ```
  $ kubectl describe pod kube-apiserver-master -n kube-system
  ```
  
  </details>
  
- Run the command kubectl get roles

  <details>
  
  ```
  $ kubectl get roles
  ```
  
  </details>
  
- Run the command kubectl get roles --all-namespaces
  
  <details>
  
  ```
  $ kubectl get roles --all-namespaces
  ```
  
  </details>
  
- Run the command kubectl describe role kube-proxy -n kube-system
  
  <details>
  
  ```
  $ kubectl describe role kube-proxy -n kube-system
  ```
  
  </details>
  
- Check the verbs associated to the kube-proxy role
  
  <details>
  ```
  $ kubectl describe role kube-proxy -n kube-system
  ```
  </details>
  
- Which of the following statements are true?
  
  <details>
  ```
  kube-proxy role can get details of configmap object by the name kube-proxy
  ```
  </details>
  
- Run the command kubectl describe rolebinding kube-proxy -n kube-system
  
  <details>
  ```
  $ kubectl describe rolebinding kube-proxy -n kube-system
  ```
  </details>
  
- Run the command kubectl get pods --as dev-user
  
  <details>
  ```
  $ kubectl get pods --as dev-user
  ```
  </details>
  
- Answer file located at /var/answers
  
  <details>
  
  ```
  $ kubectl create -f /var/answers/developer-role.yaml
  ```
  
  </details>
  
- New roles and role bindings are created in the blue namespace. Check it out. Check the resourceNames configured on the role
  
  <details>
  
  ```
  $ kubectl get roles,rolebindings -n blue
  $ kubectl describe role developer -n blue
  $ kubectl edit role developer -n blue (update the resourceNames)
  ```
  
  </details>
  
- View the answer file located at /var/answers/dev-user-deploy.yaml
  
  <details>
  
  ```
  $ kubectl create -f /var/answers/dev-user-deploy.yaml
  ```
  
  </details>
