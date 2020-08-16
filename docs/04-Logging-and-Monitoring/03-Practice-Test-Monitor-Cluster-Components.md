# Practice Test - Monitor Cluster Components
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816628)
  
Solutions to practice test - monitor cluster components
- We have deployed a few PODs running workloads. Inspect it.

  <details>
  
  ```
  $ kubectl get pods
  ```
  </details>
  
- Let us deploy metrics-server to monitor the PODs and Nodes. Pull the git repository for the deployment files.

  <details>
  
  ```
  $ git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
  ```
  </details>
  
- Run the 'kubectl create -f .' command from within the downloaded repository.

  <details>
  ```
  $ cd kubernetes-metrics-server
  $ kubectl create -f .
  ```
  </details>
    
- Run the 'kubectl top node' command and wait for a valid output.

  <details>
  ```
  $ kubectl top node
  ```
  </details>
  
- Run the 'kubectl top node' command

  <details>
  ```
  $ kubectl top node
  ```
  </details>
  
- Run the 'kubectl top node' command
  
  <details>
  ```
  $ kubectl top node
  ```
  </details>
  
- Run the 'kubectl top pod' command
  
  <details>
  ```
  $ kubectl top pod
  ```
  </details>
  
- Run the 'kubectl top pod' command
  
  <details>
  ```
  $ kubectl top pod
  ```
  </details>
  
#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290102)
