# Practice Test - Manual Scheduling
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816587)

Solutions to Practice Test - Manual Scheduling

- Run, **`kubectl create -f nginx.yaml`**
  
  <details>

  ```
  $ kubectl create -f nginx.yaml
  ```
  </details>

- Run the command 'kubectl get pods' and check the status column

  <details>

  ```
  $ kubectl get pods
  ```
  </details>

- Run the command 'kubectl get pods --namespace kube-system'

  <details>

  ```
  $ kubectl get pods --namespace kube-system
  ```
  </details>

- Set **`nodeName`** property on the pod to node01 node

  <details>

  ```
  $ vi nginx.yaml
  $ kubectl delete -f nginx.yaml
  $ kubectl create -f nginx.yaml
  ```
  </details>

- Set **`nodeName`** property on the pod to master node

  <details>

  ```
  $ vi nginx.yaml
  $ kubectl delete -f nginx.yaml
  $ kubectl create -f nginx.yaml
  ```
  </details>


#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/16603715)

