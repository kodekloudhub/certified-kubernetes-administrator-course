# Kubernetes Services
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808156)
  
In this section we will take a look at **`services`** in kuberentes

## Services
- Kubernetes Services enables communication between various components within an outside of the application.
- Kubernetes Services helps us connect applications together with other applications or users.
- Services enables frontend applications to be made available to endusers. It helps communications between **`backend`** and **`frontend`** pods and it helps to establish connecivity to an **`external datasource`**
- Thus, services enables loose coupling between microservices in our application.
  ![srv1](../../images/srv1.PNG)
  
#### Let's look at some other aspects of networking

## External Communication

- So, we deployed our **`POD`** having a **`web application`** on it. How do we as an **`external user`** access the **`web page`**?

  - From the node (Able to reach the application as expected)
  
    ![srv2](../../images/srv2.PNG)
    
  - From outside world (This should be our expectation, without something in the middle it will not reach the application)
  
    ![srv3](../../images/srv3.PNG)
    
  - We need something in the middle to help us to map requests to the node (say from our laptop through the node to the pod running the web container). This is where the **`kubernetes service`** comes into play.
    
    ![srv4](../../images/srv4.PNG)

  - This type of service is know as a **`Node Port`** service, because the service listens to a pod on the node and forward requests to the POD.
    
 ## Service Types
 
 #### There are 3 types of service types in kubernetes
 
   ![srv-types](../../images/srv-types.PNG)
 
 1. NodePort
    - Where the services makes an internal POD accessable on a POD on the NODE.
      ```
      apiVersion: v1
      kind: Service
      metadata:
       name: myapp-service
      spec:
       types: NodePort
       ports:
       - targetPort: 80
         port: 80
         nodePort: 30008
      ```
     ![srvnp](../../images/srvnp.PNG)
      
      #### To connect the service to the pod
      ```
      apiVersion: v1
      kind: Service
      metadata:
       name: myapp-service
      spec:
       types: NodePort
       ports:
       - targetPort: 80
         port: 80
         nodePort: 30008
       selector:
         app: myapp
         type: front-end
       ```

    ![srvnp1](../../images/srvnp1.PNG)
      
      #### To create the service
      ```
      $ kubectl create -f service-defination.yaml
      ```
      
      #### To list the services
      ```
      $ kubectl get services
      ```
      
      #### To access the application from CLI instead of web browser
      ```
      $ curl http://192.168.1.2:30008
      ```
      
      ![srvnp2](../../images/srvnp2.PNG)

      #### A service with multiple pods
      
      ![srvnp3](../../images/srvnp3.PNG)
      
      #### When Pods are distributed across multiple nodes
     
      ![srvnp4](../../images/srvnp4.PNG)
     
            
 1. ClusterIP
    - In this case the service creates a **`Virtual IP`** inside the cluster to enable communication between different services such as a set of frontend servers to a set of backend servers.
    
 1. LoadBalancer
    - Where provisions a **`loadbalancer`** for our application in supported cloud providers.
    
K8s Reference Docs:
- https://kubernetes.io/docs/concepts/services-networking/service/
- https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/

