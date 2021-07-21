# Practice Test - Multiple Schedulers
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-multiple-schedulers/)
  
Solutions to practice test - multiple schedulers
- Run the command 'kubectl get pods --namespace=kube-system'
  
  <details>

  ```
  $ kubectl get pods --namespace=kube-system
  ```
  </details>

- Run the command 'kubectl describe pod kube-scheduler-master --namespace=kube-system'

  <details>

  ```
  $ kubectl describe pod kube-scheduler-master --namespace=kube-system
  ```
  </details>

- Use the file at /etc/kubernetes/manifests/kube-scheduler.yaml to create your own scheduler. View answer file at /var/answers

  <details>

  ```
  $ kubectl create -f my-scheduler.yaml
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


