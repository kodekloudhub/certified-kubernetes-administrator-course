# Practice Test - Monitor Cluster Components
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816628)
  
Solutions to practice test - monitor cluster components
- We have deployed a few PODs running workloads. Inspect it.
  ```
  $ kubectl get pods
  ```
- Let us deploy metrics-server to monitor the PODs and Nodes. Pull the git repository for the deployment files.
  ```
  $ git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
  ```
- Run the 'kubectl create -f .' command from within the downloaded repository.
  ```
  $ cd kubernetes-metrics-server
  $ kubectl create -f .
  ```
- Run the 'kubectl top node' command and wait for a valid output.
  ```
  $ kubectl top node
  ```
- Run the 'kubectl top node' command
  ```
  $ kubectl top node
  ```
- Run the 'kubectl top node' command
  ```
  $ kubectl top node
  ```
- Run the 'kubectl top pod' command
  ```
  $ kubectl top pod
  ```
- Run the 'kubectl top pod' command
  ```
  $ kubectl top pod
  ```
  
#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290102)
