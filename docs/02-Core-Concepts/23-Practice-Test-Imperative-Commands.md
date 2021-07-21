# Practice Test - Imperative Commands
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-imperative-commands-2/)
  
Solutions for Practice Test - Imperative Commands

- Run the command **`kubectl run nginx-pod --image=nginx:alpine`**. 
  
  <details>

  ```
  $ kubectl run nginx-pod --image=nginx:alpine
  ```
  </details>

- Run the command **`kubectl run redis --image=redis:alpine -l tier=db`**.

  <details>

  ```
  $ kubectl run redis --image=redis:alpine -l tier=db
  ```
  </details>

- Run the command **`kubectl expose pod redis --port=6379 --name redis-service`**.

  <details>

  ```
  $ kubectl expose pod redis --port=6379 --name redis-service
  ```
  </details>

- Run the command **`kubectl create deployment webapp --image=kodekloud/webapp-color`**. Then scale the webapp to 3 using command **`kubectl scale deployment/webapp --replicas=3`**.

  <details>

  ```
  $ kubectl create deployment webapp --image=kodekloud/webapp-color
  $ kubectl scale deployment/webapp --replicas=3
  ```
  </details>

- Run the command **`kubectl run custom-nginx --image=nginx --port=8080`**.

  <details>

  ```
  $ kubectl run custom-nginx --image=nginx --port=8080
  ```
  </details>

- Run the command **`kubectl create ns dev-ns`**.
  
  <details>

  ```
  $ kubectl create ns dev-ns
  ```
  </details>

- Run the command to create a deployment.

  <details>

  ```
  Step 1: Create the deployment YAML file
  $ kubectl create deployment redis-deploy --image redis --namespace=dev-ns --dry-run=client -o yaml > deploy.yaml
  $ kubectl create -f deploy.yaml

  Step 2: Edit the YAML file and add update the replicas to 2.
  
  Step 3: Run kubectl apply -f deploy.yaml to create the deployment in the dev-ns namespace.
  $ kubectl apply -f deploy.yaml

  You can also use kubectl scale deployment or kubectl edit deployment to change the number of replicas once the object has been created.
  $ kubectl edit deployment redis-deploy
  $ kubectl scale deployment/redis-deploy --replicas=2 --namespace=dev-ns
  
  In v1.19, kubectl create deployment supports "--replicas" flag to increase the count number.
  $ kubectl create deployment redis-deploy --image=redis --namespace=dev-ns --replicas=2 
  ```
  </details>

- First create a YAML file for both the pod and service like this: **`kubectl run httpd --image=httpd:alpine --port=80 --expose`**.

  <details>

  ```
  $ kubectl run httpd --image=httpd:alpine --port=80 --expose
  ```
  </details>

  
