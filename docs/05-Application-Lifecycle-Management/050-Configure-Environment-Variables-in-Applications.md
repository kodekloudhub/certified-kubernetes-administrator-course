# Configure Environment Variables In Applications
  - Take me to [Video Tutorial](https://kodekloud.com/topic/configure-environment-variables-in-applications/)
  
#### ENV variables in Docker
```
$ docker run -e APP_COLOR=pink simple-webapp-color
```

#### ENV variables in kubernetes 
- To set an environment variable set an **`env`** property in pod definition file.
  
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: simple-webapp-color
  spec:
   containers:
   - name: simple-webapp-color
     image: simple-webapp-color
     ports:
     - containerPort: 8080
     env:
     - name: APP_COLOR
       value: pink
  ```
  ![env](../../images/env.PNG)
  
- There are other ways of setting the environment variables such as **`ConfigMaps`** and **`Secrets`**

  ![cms](../../images/cms.PNG)
  
#### K8s Reference Docs
- https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/
