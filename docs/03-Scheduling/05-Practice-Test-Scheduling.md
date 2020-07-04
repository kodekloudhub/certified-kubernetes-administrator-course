# Practice Test - Scheduling
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9816589)
  
Solutions to Practice Test - Scheduling
- Run the command 'kubectl get pods --selector env=dev'
  ```
  $ kubectl get pods --selector env=dev
  ```
- Run the command 'kubectl get pods --selector bu=finance'
  ```
  $ kubectl get pods --selector bu=finance
  ```
- Run the command 'kubectl get all --selector env=prod'
  ```
  $ kubectl get all --selector env=prod
  ```
- Run the command 'kubectl get all --selector env=prod,bu=finance,tier=frontend'
  ```
  $ kubectl get all --selector env=prod,bu=finance,tier=frontend
  ```
- Set the labels on the pod definition template to frontend
  ```
  $ vi replicaset-defination.yaml
  $ kubectl create -f replicaset-defination.yaml
  ```
  
#### Take to [Practice Test - Scheduling](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290011)
