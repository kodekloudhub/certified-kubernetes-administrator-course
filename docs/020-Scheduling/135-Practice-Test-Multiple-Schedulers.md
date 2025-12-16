# Practice Test - Multiple Schedulers
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-multiple-schedulers/)
  
Solutions to practice test - multiple schedulers
- Run the command 'kubectl get pods --namespace=kube-system'
  
  <details>

  ```
  $ kubectl get pods --namespace=kube-system
  ```
  </details>

- Run the command 'kubectl describe pod kube-scheduler-controlplane --namespace=kube-system'

  <details>

  ```
  $ kubectl describe pod kube-scheduler-controlplane --namespace=kube-system
  ```
  </details>
  
- Use the imperative command to create the configmap with option --from-file

  <details>

  ```
  $ kubectl create -n kube-system configmap my-scheduler-config --from-file=/root/my-scheduler-config.yaml
  ```
  </details>

- Use the file at /root/my-scheduler.yaml to create your own scheduler with correct image.


  <details>

  ```
  $ kubectl create -f /root/my-scheduler.yaml
  ```
  </details>

- Set schedulerName property on pod specification to the name of the new scheduler. File is located at /root/nginx-pod.yaml
  
  <details>

  ```
  master $ grep schedulerName /root/nginx-pod.yaml
  schedulerName: my-scheduler
  
  $ kubectl create -f /root/nginx-pod.yaml
  ```
  </details>


