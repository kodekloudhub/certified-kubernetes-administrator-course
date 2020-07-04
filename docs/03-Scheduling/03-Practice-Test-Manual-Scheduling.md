# Practice Test - Manual Scheduling
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816587)

Solutions to Practice Test - Manual Scheduling

- Run, **`kubectl create -f nginx.yaml`**
  ```
  $ kubectl create -f nginx.yaml
  ```
- Run the command 'kubectl get pods' and check the status column
  ```
  $ kubectl get pods
  ```
- Run the command 'kubectl get pods --namespace kube-system'
  ```
  $ kubectl get pods --namespace kube-system
  ```
- Set **`nodeName`** property on the pod to node01 node
  ```
  $ vi nginx.yaml
  $ kubectl delete -f nginx.yaml
  $ kubectl create -f nginx.yaml
  ```
- Set **`nodeName`** property on the pod to master node
  ```
  $ vi nginx.yaml
  $ kubectl delete -f nginx.yaml
  $ kubectl create -f nginx.yaml
  ```

#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/16603715)

