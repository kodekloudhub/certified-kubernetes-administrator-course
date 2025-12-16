# Practice Test Env Variables
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-env-variables/)
  
Solutions to practice test env variables
- Run the command 'kubectl get pods' and count the number of pods.
  
  <details>
  
  ```
  $ kubectl get pods
  ```
  
  </details>
  
- Run the command 'kubectl describe pod' and look for ENV option

  <details>
  
  ```
  $ kubectl describe pod
  ```
  
  </details>
  
- Run the command 'kubectl describe pod' and look for ENV option
  
  <details>
  
  ```
  $ kubectl describe pod
  ```
  
  </details>
    
- View the web application UI by clicking on the 'Webapp Color' Tab above your terminal.

- Set the environment option to APP_COLOR - green.
  
  <details>
  
  ```
  $ kubectl get pods webapp-color -o yaml > green.yaml
  $ kubectl delete pods webapp-color
  Update APP_COLOR to green
  $ kubectl create -f green.yaml
  ```
  
  </details>
  
- View the changes to the web application UI by clicking on the 'Webapp Color' Tab above your terminal.

- Run kubectl get configmaps
  
  <details>
  
  ```
  $ kubectl get configmaps
  ```
  
  </details>
  
- Run the command 'kubectl describe configmaps' and look for DB_HOST option

  <details>
  
  ```
  $ kubectl describe configmaps
  ```
  
  </details>
  
- Create a new ConfigMap for the 'webapp-color' POD. Use the spec given on the right.

  <details>
  
  ```
  $ kubectl create configmap webapp-config-map --from-literal=APP_COLOR=darkblue
  ```
  
  </details>
  
- Set the environment option to envFrom and use configMapRef webapp-config-map.
  
  <details>
  
  ```
  $ kubectl get pods webapp-color -o yaml > new-webapp.yaml
  $ kubectl delete pods webapp-color
   Update pod definition file, under spec.containers section update the below.
  - envFrom:
    - configMapRef:
       name: webapp-config-map
  ```
  
  </details>
  
  <details>
  
  ```
  $ kubectl create -f new-webapp.yaml
  ``` 
  
  </details>

- View the changes to the web application UI by clicking on the 'Webapp Color' Tab above your terminal.
