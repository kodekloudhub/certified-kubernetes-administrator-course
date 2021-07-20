# Practice Test - Init-Containers
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-init-containers/)
  
Solutions to practice test - init-containers
- Identify the pod that has an initContainer configured.

  <details>
  ```
  $ kubectl get pods
  $ kubectl describe pods
  ```
  </details>
  
- What is the image used by the initContainer on the blue pod?
  
  <details>
  ```
  $ kubectl describe pods blue
  ```
  </details>
    
- Run the command kubectl describe pod blue and check the state field of the initContainer.

  <details>
  ```
  $ kubectl describe pod blue
  ```
  </details>
  
- Check the reason field of the initContainer
  
  <details>
  ```
  $ kubectl describe pod blue
  ```
  </details>
  
- Run the command kubectl describe pod purple
  
  <details>
  ```
  $ kubectl describe pod purple
  ```
  </details>
  
- Run the kubectl describe pod purple command and look at the container state
  
  <details>
  ```
  $ kubectl describe pod purple
  ```
  </details>
  
- Check the commands used in the initContainers. The first one sleeps for 600 seconds (10 minutes) and the second one sleeps for 1200 seconds (20 minutes)
  
  <details>
  ```
  $ kubectl describe pod purple
  ```
  </details>
  
- Update the pod red to use an initContainer that uses the busybox image and sleeps for 20 seconds
  
  <details>
  ```
  $ kubectl get pod red -o yaml > red.yaml
  $ kubectl delete pod red
  ```
  </details>
  
  Update the red.yaml with sleep 20 seconds
  
  <details>
  ```
  $ kubectl create -f red.yaml
  ```
  </details>
  
- Check the command used by the initContainer. Looks like there is a type in sleep command. Fix it, it should be **`sleep 2`** not **`sleeeep 2`**
  
  <details>
  ```
  $ kubectl describe pod orange
  $ kubectl get pod orange -o yaml > orange.yaml
  $ kubectl delete pod orange
  
  Update the orange.yaml with correct sleep command and recreate the pod
  $ kubectl create -f orange.yaml
  ```
 </details>
