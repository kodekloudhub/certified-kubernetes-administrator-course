# Practice Test Env Variables
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816643)
  
Solutions to practice test env variables
- Run the command 'kubectl get pods' and count the number of pods.
  ```
  $ kubectl get pods
  ```
- Run the command 'kubectl describe pod' and look for ENV option
  ```
  $ kubectl describe pod
  ```
- Run the command 'kubectl describe pod' and look for ENV option
  ```
  $ kubectl describe pod
  ```
- View the web application UI by clicking on the 'Webapp Color' Tab above your terminal.

- Set the environment option to APP_COLOR - green.
  ```
  $ kubectl get pods webapp-color -o yaml > green.yaml
  $ kubectl delete pods webapp-color
  
  Update APP_COLOR to green
  $ kubectl create -f green.yaml
  ```
- View the changes to the web application UI by clicking on the 'Webapp Color' Tab above your terminal.

- Run kubectl get configmaps
  ```
  $ kubectl get configmaps
  ```
- Run the command 'kubectl describe configmaps' and look for DB_HOST option
  ```
  $ kubectl describe configmaps
  ```
- Create a new ConfigMap for the 'webapp-color' POD. Use the spec given on the right.
  ```
  $ kubectl create configmap webapp-config-map --from-literal=APP_COLOR=darkblue
  ```
  
- Set the environment option to envFrom and use configMapRef webapp-config-map.
  ```
  $ kubectl get pods webapp-color -o yaml > new-webapp.yaml
  $ kubectl delete pods webapp-color
  
  Update pod defination file, under spec.containers section update the below.
  ```
  - envFrom:
     - configMapRef:
         name: webapp-config-map
  ```
  ```
  $ kubectl create -f new-webapp.yaml
  ``` 

- View the changes to the web application UI by clicking on the 'Webapp Color' Tab above your terminal.





