# Practice Test - Image Security
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816673)

Solutions to the practice test - Image Security
- We have an application running on our cluster. Let us explore it first. What image is the application using?

  <details>
  
  ```
  $ kubectl get deploy -o wide
  ```
  
  </details>
  
- Use the kubectl edit deployment command to edit the image name to myprivateregistry.com:5000/nginx:alpine

  <details>
  
  ```
  $ kubectl edit deployment web
  ```
  
  </details>
  
- Run the command kubectl get pods command and check the status of the pods

  <details>
  
  ```
  $ kubectl get pods
  ```
  
  </details>
  
- Run command kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com
  
  <details>
  
  ```
  $ kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com
  ```
  
  </details>
  
- Edit deployment using kubectl edit deploy web command and add imagePullSecrets section. Use private-reg-cred
  
  <details>
  
  ```
  $ kubectl edit deploy web
  ```
  
  </details>
  
- Check the status of PODs. Wait for them to be running. You have now successfully configured a Deployment to pull images from the private registry
  
  <details>
  
  ```
  $ kubectl get pods
  ```
  </details>
