# Practice Test - Imperative Commands
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/10503277)
  
Solutions for Practice Test - Imperative Commands

- Use the command kubectl run nginx-pod --image=nginx:alpine
  ```
  $ kubectl run nginx-pod --image=nginx:alpine
  ```
- Use the command kubectl run redis --image=redis:alpine -l tier=db
  ```
  $ kubectl run redis --image=redis:alpine -l tier=db
  ```
- Run the command kubectl expose pod redis --port=6379 --name redis-service
  ```
  $ kubectl expose pod redis --port=6379 --name redis-service
  ```
- Use the command kubectl create deployment webapp --image=kodekloud/webapp-color. The scale the webapp to 3 using command kubectl scale deployment/webapp --replicas=3
  ```
  $ kubectl create deployment webapp --image=kodekloud/webapp-color
  $ kubectl scale deployment/webapp --replicas=3
  ```
- Run kubectl run custom-nginx --image=nginx --port=8080
  ```
  $ kubectl run custom-nginx --image=nginx --port=8080
  ```
- Run kubectl create ns dev-ns
  ```
  $ kubectl create ns dev-ns
  ```
- To create deployment
  ```
  Step 1: Create the deployment YAML file
  $ kubectl create deployment redis-deploy --image redis --namespace=dev-ns --dry-run=client -o yaml > deploy.yaml
  $ kubectl create -f deploy.yaml

  Step 2: Edit the YAML file and add update the replicas to 2
  
  Step 3: Run kubectl apply -f deploy.yaml to create the deployment in the dev-ns namespace.
  $ kubectl apply -f deploy.yaml

  You can also use kubectl scale deployment or kubectl edit deployment to change the number of replicas once the object has been created.
  $ kubectl edit deployment redis-deploy
  $ kubectl scale deployment/redis-deploy --replicas=2 --namespace=dev-ns
  ```
- First create a YAML file for both the pod and service like this: kubectl run httpd --image=httpd:alpine --port=80 --expose
  ```
  $ kubectl run httpd --image=httpd:alpine --port=80 --expose
  ```
  
