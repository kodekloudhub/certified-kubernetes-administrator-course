# Practice Test - Scheduling
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9816589)
  
Solutions to Practice Test - Scheduling
- Run the command 'kubectl get pods --selector env=dev'
  
  <details>

  ```
  $ kubectl get pods --selector env=dev
  ```
  </details>

- Run the command 'kubectl get pods --selector bu=finance'

  <details>

  ```
  $ kubectl get pods --selector bu=finance
  ```
  </details>

- Run the command 'kubectl get all --selector env=prod'

  <details>

  ```
  $ kubectl get all --selector env=prod
  ```
  </details>

- Run the command 'kubectl get all --selector env=prod,bu=finance,tier=frontend'
  
  <details>

  ```
  $ kubectl get all --selector env=prod,bu=finance,tier=frontend
  ```
  </details>

- Set the labels on the pod definition template to frontend

  <details>

  ```
  $ vi replicaset-definition.yaml
  $ kubectl create -f replicaset-definition.yaml
  ```
  </details>

  
#### Take to [Practice Test - Scheduling](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290011)
