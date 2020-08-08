# Security Context
  - Take me to [Video Tutorial]()
  
In this section, we will take a look at security context

## Container Security
 
 ![csec](../../images/csec.PNG)
 
## Kubernetes Security
- You may choose to configure the security settings at a container level or at a pod level.
- If you configure it at a pod level the settings will carry over all the containers within the pod.
- If you configure it at both the pod and the container the settings on the container will override the settings on the pod.

 ![ksec](../../images/ksec.PNG)

## Security Context
- To add security context on the container and a field called **`securityContext`** under the spec section.

  ![sxc1](../../images/sxc1.PNG)
  
- To set the same context at the container level, then move the whole section under container section.

  ![sxc2](../../images/sxc2.PNG)
  
- To add capabilities use the **`capabilities`** option

  ![cap](../../images/cap.PNG)
  
  
 
