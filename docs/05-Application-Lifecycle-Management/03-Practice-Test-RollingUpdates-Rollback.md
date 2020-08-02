# Practice Test - Rolling Updates and Rollback
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816638)
  
Solutions to practice test - rolling updates and rollback
- We have deployed a simple web application. Inspect the PODs and the Services
  ```
  $ kubectl get pods
  $ kubectl get services
  ```
- What is the current color of the web application?
  ```
  Access the web portal
  ```
- Execute the script at /root/curl-test.sh.

- Run the command 'kubectl describe deployment' and look at 'Desired Replicas'
  ```
  $ kubectl describe deployment
  ```
- Run the command 'kubectl describe deployment' and look for 'Images'
  ```
  $ kubectl describe deployment
  ```
- Run the command 'kubectl describe deployment' and look at 'StrategyType'
  ```
  $ kubectl describe deployment
  ```
- If you were to upgrade the application now what would happen?
  ```
  PODs are upgraded few at a time
  ```
- Run the command 'kubectl edit deployment frontend' and modify the required feild
  ```
  $ kubectl edit deployment frontend
  ```
- Execute the script at /root/curl-test.sh.

- Look at the Max Unavailable value under RollingUpdateStrategy in deployment details
  ```
  $ kubectl describe deployment
  ```
- Run the command 'kubectl edit deployment frontend' and modify the required field. Make sure to delete the properties of rollingUpdate as well, set at 'strategy.rollingUpdate'.
  ```
  $ kubectl edit deployment frontend
  ```
- Run the command 'kubectl edit deployment frontend' and modify the required feild
  ```
  $ kubectl edit deployment frontend
  ```
- Execute the script at /root/curl-test.sh.

#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/539883/lectures/13290086)



  


  




#### Take me to [Practice Test - Solutions](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/13290086)
