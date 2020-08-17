# Practice Test - Managing Application Logs
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816636)
  
Solutions to practice test - managing application logs
- We have deployed a POD hosting an application. Inspect it. Wait for it to start.

  <details>
  ```
  $ kubectl get pods
  ```
  </details>
  
- Inspect the logs of the POD
  
  <details>
  ```
  $ kubectl logs webapp-1
  ```
  </details>
  
- We have deployed a new POD - 'webapp-2' - hosting an application. Inspect it. Wait for it to start.

  <details>
  ```
  $ kubectl get pods
  ```
  </details>
  
- Inspect the logs of the webapp in the POD
  
  <details>
  ```
  $ kubectl logs webapp-2
  ```
  </details>



#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13291091)
