# Practice Test - Init-Containers
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/10589190)
  
Solutions to practice test - init-containers
- Identify the pod that has an initContainer configured.
  ```
  $ kubectl get pods
  $ kubectl describe pods
  ```
- What is the image used by the initContainer on the blue pod?
  ```
  $ kubectl describe pods blue
  ```
- Run the command kubectl describe pod blue and check the state field of the initContainer.
  ```
  $ kubectl describe pod blue
  ```
- Check the reason field of the initContainer
  ```
  $ kubectl describe pod blue
  ```
- Run the command kubectl describe pod purple
  ```
  $ kubectl describe pod purple
  ```
- Run the kubectl describe pod purple command and look at the container state
  ```
  $ kubectl describe pod purple
  ```
- Check the commands used in the initContainers. The first one sleeps for 600 seconds (10 minutes) and the second one sleeps for 1200 seconds (20 minutes)
  ```
  $ kubectl describe pod purple
  ```
- Update the pod red to use an initContainer that uses the busybox image and sleeps for 20 seconds
  ```
  $ kubectl get pod red -o yaml > red.yaml
  $ kubeclt delete pod red
  ```
  Update the red.yaml with sleep 20 seconds
  ```
  $ kubectl create -f red.yaml
  ```
- Check the command used by the initContainer. Looks like there is a type in sleep command. Fix it, it should be **`sleep 2`** not **`sleeeep 2`**
  ```
  $ kubectl describe pod orange
  $ kubectl get pod orange -o yaml > orange.yaml
  $ kubectl delete pod orange
  
  Update the orange.yaml with correct sleep command and recreate the pod
  $ kubectl create -f orange.yaml
  ```
  
  
  


