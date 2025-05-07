# Practice Test - Secrets
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-secrets/)

Solutions for pracice test - Secrets
- Run the command 'kubectl get secrets' and count the number of pods.
  
  <details>
  ```
  $ kubectl get secrets
  ```
  </details>
    
- Run the command 'kubectl get secrets' and look at the DATA field

  <details>
  ```
  $ kubectl get secrets
  ```
  </details>
  
- Run the command 'kubectl describe secret'

  <details>
  ```
  $ kubectl describe secret
  ```
  </details>
    
- Run the command 'kubectl describe secret'

  <details>
  ```
  $ kubectl describe secret
  ```
  </details>
  
- We have already deployed the required pods and services. Check out the pods and services created. Check out the web application using the 'Webapp MySQL' link above your terminal, next to the Quiz Portal Link.

- Run command kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DBUser=root --from-literal=DB_Password=password123

  <details>
  ```
  $ kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
  ```
  </details>
  
- Check Answer at /var/answers/answer-webapp.yaml

  <details>
  ```
  $ kubectl get pod webapp-pod -o yaml > web.yaml
  $ kubectl delete pod webapp-pod
  ```
  </details>
  
  Update web.yaml with secret section
  
  envFrom:
  - secretRef:
      name: db-secret
  
  <details>
  ```
  $ kubectl create -f web.yaml
  ```
  </details>
  
- View the web application to verify it can successfully connect to the database

