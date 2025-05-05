# Multi-Container Pods
  - Take me to [Video Tutorial](https://kodekloud.com/topic/multi-container-pods-2/)

In this section, we will take a look at multi-container pods

## Monolith and Microservices

  ![loga](../../images/loga.PNG)
  
#### Multi-Container Pods

  ![mcp](../../images/mcp.PNG)
  
- To create a new multi-container pod, add the new container information to the pod definition file.
  ```
  apiVersion: v1
  kind: Pod
  metadata:
    name: simple-webapp
    labels:
      name: simple-webapp
  spec:
    containers:
    - name: simple-webapp
      image: simple-webapp
      ports:
      - ContainerPort: 8080
    - name: log-agent
      image: log-agent
  ```
  ![mcpc](../../images/mcpc.PNG)
 
#### K8s Reference Docs
- https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/
