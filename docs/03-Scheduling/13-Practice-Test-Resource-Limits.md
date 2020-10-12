# Practice Test - Resource Limits
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816593)
  
Solutions to practice test - resource limtis
- Run the command 'kubectl describe pod rabbit' and inspect requests.
  
  <details>

  ```
  $ kubectl describe pod rabbit
  ```
  </details>

- Run the command 'kubectl delete pod rabbit'.

  <details>

  ```
  $ kubectl delete pod rabbit
  ```
  </details>

- Run the command 'kubectl get pods' and inspect the status of the pod elephant

  <details>

  ```
  $ kubectl get pods
  ```
  </details>

- The status 'OOMKilled' indicates that the pod ran out of memory. Identify the memory limit set on the POD.

- Generate a template of the existing pod.

  <details>

  ```
  $ kubectl get pods elephant -o yaml > elephant.yaml
  ```
  </details>

  Update the elephant.yaml pod definition with the resource memory limits to 20Mi
  
  <details>

  ```
  resources:
      limits:
        memory: 20Mi
  ---
  </details>

  Delete the pod and recreate it.
  
  <details>

  ```
  $ kubectl delete pod elephant
  $ kubectl create -f elephant.yaml
  ```
  </details>

- Inspect the status of POD. Make sure it's running
  
  <details>

  ```
  $ kubectl get pods
  ```
  </details>

- Run the command 'kubectl delete pod elephant'.

  <details>

  ```
  $ kubectl delete pod elephant
  ```
  </details>

#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290014)
