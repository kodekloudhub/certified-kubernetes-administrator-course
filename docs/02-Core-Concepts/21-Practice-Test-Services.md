# Practice Test - Services
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-services/)

#### Solutions to Practice test - Services

- Run the command **`kubectl get services`** and count the number of services.
  
  <details>

  ```
  $ kubectl get services
  ```
  </details>

- Run the command **`kubectl get services`** and look at the Type column

  <details>

  ```
  $ kubectl get services
  ```
  </details>

- Run the command **`kubectl describe service`** and look at TargetPort.

  <details>

  ```
  $ kubectl describe service|grep TargetPort
  ```
  </details>

- Run the command **`kubectl describe service`** and look at Labels

  <details>

  ```
  $ kubectl describe service
  ```
  </details>

- Run the command **`kubectl describe service`** and look at Endpoints
  
  <details>

  ```
  $ kubectl describe service
  ```
  </details>

- Run the command **`kubectl get deployment`** and count the number of pods.

  <details>

  ```
  $ kubectl get deployment
  ```
  </details>

- Run the command **`kubectl describe deployment`** and look under the containers section.

  <details>

  ```
  $ kubectl describe deployment
  ```
  </details>

- Try to access the Web Application UI using the tab simple-webapp-ui above the terminal.

- Update the given values in the service definition file and create the service.

  <details>

  ```
  $ kubectl create -f service-definition-1.yaml
  ```
  </details>
 
