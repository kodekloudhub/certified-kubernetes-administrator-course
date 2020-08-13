# Managing Application Logs
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808184)

In this section, we will take a look at managing application logs

#### Let us start with logging in docker

![ld](../..images/ld.PNG)
 
![ld1](../..images/ld1.PNG)
 
#### Logs - Kubernetes

 ![logs](../../images/logs.PNG)
 
- To view the logs
  ```
  $ kubectl logs -f event-simulator-pod
  ```
- If there are multiple containers in a pod then you must specify the name of the container explicitly in the command.
  ```
  $ kubectl logs -f <pod-name> <container-name>
  $ kubeclt logs -f even-simulator-pod event-simulator
  ```

  ![logs1](../../images/logs1.PNG)
  

 
