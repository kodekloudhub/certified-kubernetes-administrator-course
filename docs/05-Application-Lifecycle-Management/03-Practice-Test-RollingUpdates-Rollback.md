# Practice Test - Rolling Updates and Rollback
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-rolling-updates-and-rollbacks/)
  
Solutions to practice test - rolling updates and rollback
- We have deployed a simple web application. Inspect the PODs and the Services

  <details>
  
  ```
  $ kubectl get pods
  $ kubectl get services
  ```
  </details>
  
- What is the current color of the web application?
  
  <details>
  
  ```
  Access the web portal
  ```
  </details>
    
- Execute the script at /root/curl-test.sh.

- Run the command 'kubectl describe deployment' and look at 'Desired Replicas'

  <details>
  
  ```
  $ kubectl describe deployment
  ```
  </details>
  
- Run the command 'kubectl describe deployment' and look for 'Images'
  
  <details>
  
  ```
  $ kubectl describe deployment
  ```
  </details>
  
- Run the command 'kubectl describe deployment' and look at 'StrategyType'
  
  <details>
  
  ```
  $ kubectl describe deployment
  ```
  </details>
  
- If you were to upgrade the application now what would happen?
  
  <details>
  
  ```
  PODs are upgraded few at a time
  ```
  </details>
  
- Run the command 'kubectl edit deployment frontend' and modify the required feild
  
  <details>
  
  ```
  $ kubectl edit deployment frontend
  ```
  </details>
    
- Execute the script at /root/curl-test.sh.

- Look at the Max Unavailable value under RollingUpdateStrategy in deployment details

  <details>
  ```
  $ kubectl describe deployment
  ```
  </details>
  
- Run the command 'kubectl edit deployment frontend' and modify the required field. Make sure to delete the properties of rollingUpdate as well, set at 'strategy.rollingUpdate'.
  
  <details>
  
  ```
  $ kubectl edit deployment frontend
  ```
  
  </details>
  
- Run the command 'kubectl edit deployment frontend' and modify the required feild

  <details>
  
  ```
  $ kubectl edit deployment frontend
  ```
  </details>
  
- Execute the script at /root/curl-test.sh.




