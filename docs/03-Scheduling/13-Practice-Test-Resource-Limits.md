# Practice Test - Resource Limits
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816593)
  
Solutions to practice test - resource limtis
- Run the command 'kubectl describe pod rabbit' and inspect requests.
  ```
  $ kubectl describe pod rabbit
  ```
- Run the command 'kubectl delete pod rabbit'.
  ```
  $ kubectl delete pod rabbit
  ```
- Run the command 'kubectl get pods' and inspect the status of the pod elephant
  ```
  $ kubectl get pods
  ```
- The status 'OOMKilled' indicates that the pod ran out of memory. Identify the memory limit set on the POD.

- Generate a template of the existing pod.
  ```
  $ kubectl get pods elephant -o yaml > elephant.yaml
  ```
  Update the elephant.yaml pod defination with the resource memory limits to 20Mi
  ```
  resources:
      limits:
        memory: 20Mi
  ---
  Delete the pod and recreate it.
  ```
  $ kubectl delete pod elephant
  $ kubectl create -f elephant.yaml
  ```
- Inspect the status of POD. Make sure it's running
  ```
  $ kubectl get pods
  ```
- Run the command 'kubectl delete pod elephant'.
  ```
  $ kubectl delete pod elephant
  ```
  
#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290014)
