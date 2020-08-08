# Practice Test - RBAC
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816669)

Solutions to practice test - RBAC
- Run the command kubectl describe pod kube-apiserver-master -n kube-system and look for --authorization-mode
  ```
  $ kubectl describe pod kube-apiserver-master -n kube-system
  ```
- Run the command kubectl get roles
  ```
  $ kubectl get roles
  ```
- Run the command kubectl get roles --all-namespaces
  ```
  $ kubectl get roles --all-namespaces
  ```
- Run the command kubectl describe role kube-proxy -n kube-system
  ```
  $ kubectl describe role kube-proxy -n kube-system
  ```
- Check the verbs associated to the kube-proxy role
  ```
  $ kubectl describe role kube-proxy -n kube-system
  ```
- Which of the following statements are true?
  ```
  kube-proxy role can get details of configmap object by the name kube-proxy
  ```
- Run the command kubectl describe rolebinding kube-proxy -n kube-system
  ```
  $ kubectl describe rolebinding kube-proxy -n kube-system
  ```
- Run the command kubectl get pods --as dev-user
  ```
  $ kubectl get pods --as dev-user
  ```
- Answer file located at /var/answers
  ```
  $ kubectl create -f /var/answers/developer-role.yaml
  ```
- New roles and role bindings are created in the blue namespace. Check it out. Check the resourceNames configured on the role
  ```
  $ kubectl get roles,rolebindings -n blue
  $ kubectl describe role developer -n blue
  $ kubectl edit role developer -n blue (update the resourceNames)
  ```
- View the answer file located at /var/answers/dev-user-deploy.yaml
  ```
  $ kubectl create -f /var/answers/dev-user-deploy.yaml
  ```
  
