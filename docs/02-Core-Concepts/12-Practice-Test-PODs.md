# Practice Test - PODs
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9808164)

## Here are the solutions to the practice test
1. Run the command **`kubectl get pods`** and count the number of pods.
   <details>

   ```
   $ kubectl get pods
   ```
   </details>
   
1. Run the command **`kubectl run nginx --image=nginx`**
   <details>

   ```
   $ kubectl run nginx --image=nginx
   ```
   </details>

1. Run the command **`kubectl get pods`** and count the number of pods.

   <details>

   ```
   $ kubectl get pods
   ```
   </details>

1. Run the command **`kubectl describe pod newpods**`' look under the containers section.

   <details>

    ```
    $ kubectl describe pod newpods
    ```
   </details>

1. Run the command **`kubectl describe pod newpods`** or **`kubectl get pods -o wide`** look under the containers section.

   <details>

    ```
    $ kubectl describe pod newpods
    ```
   </details>

1. Run the command **`kubectl describe pod webapp`** and look under the Containers section (or) Run **`kubectl get pods`** and look under the READY section

   <details>

   ```
   $ kubectl describe pod webapp
   ```
   
   </details>

1. Run the command **`kubectl describe pod webapp`** and look under the containers section.
   
   <details>

   ```
   $ kubectl describe pod webapp
   ```
   </details>

1. Run the command **`kubectl describe pod webapp`** and look under the containers section.

   <details>

   ```
   $ kubectl describe pod webapp
   ```
   </details>

1. Run the command **`kubectl describe pod webapp`** and look under the events section.

   <details>

   ```
   $ kubectl describe pod webapp
   ```
   
   </details>

1. Run the command **`kubectl get pods`**
   
   <details>

   ```
   $ kubectl get pods
   ```
   
   </details>

1. Run the command **`kubectl delete pod webapp`**

   <details>

   ```
   $ kubectl delete pod webapp
   ```
   
   </details>

1. Create a pod definition YAML file and use it to create a POD or use the command **`kubectl run redis --image=redis123`**

   <details>

   ```
   $ kubectl run redis --image=redis123
   ```
   
   </details>

1. Now fix the image on the pod to **`redis`**. Update the pod-definition file and use **`kubectl apply`** command or use **`kubectl edit pod redis`** command.

   <details>

   ```
   $ kubectl apply
   $ kubectl edit pod redis
   ```
   
   </details>
