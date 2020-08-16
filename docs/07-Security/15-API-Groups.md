# API Groups
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808255)
  
In this section, we will take a look at API Groups in kubernetes

## To return version and list pods via API's 

 ![api3](../../images/api3.PNG)
 
- The kubernetes API is grouped into multiple such groups based on thier purpose. Such as one for **`APIs`**, one for **`healthz`**, **`metrics`** and **`logs`** etc.

  ![api4](../../images/api4.PNG)
 
## API and APIs
- These APIs are catagorized into two.
  - The core group - Where all the functionality exists
    
    ![api5](../../images/api5.PNG)
 
  - The Named group - More organized and going forward all the newer features are going to be made available to these named groups.
  
    ![api6](../../images/api6.PNG)
    
- To list all the api groups

  ![api7](../../images/api7.PNG)
  
## Note on accessing the kube-apiserver
- You have to authenticate by passing the certificate files.

  ![api8](../../images/api8.PNG)
  
- An alternate is to start a **`kubeproxy`** client
  
  ![api9](../../images/api9.PNG)
  
## kube proxy vs kubectl proxy
 
  ![kp](../../images/kp.PNG)
  
## Key Takeaways

  ![api10](../../images/api10.PNG)

#### K8s Reference Docs
- https://kubernetes.io/docs/concepts/overview/kubernetes-api/
- https://kubernetes.io/docs/reference/using-api/api-concepts/
- https://kubernetes.io/docs/tasks/extend-kubernetes/http-proxy-access-api/
