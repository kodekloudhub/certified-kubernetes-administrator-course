# Deployments
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808165)

In this section, we will take a look at kubernetes deployments

Deployment is a kubernetes object. 
- The Deployment provides us with the capability to upgrade the underline instances seemlessly using **`Rolling updates`**, **`Undo Changes`** and **`Pause`** and **`Resume Changes`** as required.
  
  ![deployment](../../images/deployment.PNG)
  
#### How do we create deployment?
- As with the previous components we created a defination file, the content of the deployment defination file is similar to **`replicaset`** defination file. Except with the **`kind`** which is now going to be **`Deployment`**.

```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myapp-deployment
      labels:
        app: myapp
        type: front-end
    spec:
     template:
        metadata:
          name: myapp-pod
          labels:
            app: myapp
            type: front-end
        spec:
         containers:
         - name: nginx-container
           image: nginx
     replicas: 3
     selector:
       matchLabels:
        type: front-end
 ```
- Once the file is ready, create the deployment using deployment defination file
  ```
  $ kubectl create -f deployment-defination.yaml
  ```
- To see the created deployment
  ```
  $ kubectl get deployment
  ```
- The deployment automatically creates a **`ReplicaSet`**. To see the replicasets
  ```
  $ kubeclt get replicaset
  ```
- The replicasets ultimately creates **`PODs`**. To see the PODs
  ```
  $ kubectl get pods
  ```
    
  ![deployment1](../../images/deployment1.PNG)
  
- To see the all objects at once
  ```
  $ kubectl get all
  ```
  ![deployment2](../../images/deployment2.PNG)
  
K8s Reference Docs:
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/
- https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/
- https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/
  
  
  
  
  
 
