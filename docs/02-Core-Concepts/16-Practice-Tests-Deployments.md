# Practice Test - Deployments
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816571)
  
Solutions to the deploments practice test
1. Run the command **`kubectl get pods`** and count the number of pods.
   
   <details>

   ```
   $ kubectl get pods
   ```
   </details>

1. Run the command **`kubectl get replicaset`** and count the number of ReplicaSets.
   
   <details>

   ```
   $ kubectl get replicaset (or)
   $ kubectl get rs
   ```
   </details>

1. Run the command **`kubectl get deployment`** and count the number of Deployments.
   
   <details>

   ```
   $ kubectl get deployment
   ```
   </details>

1. Run the command **`kubectl get deployment`** and count the number of Deployments.
   
   <details>

   ```
   $ kubectl get deployment
   ```
   </details>

1. Run the command **`kubectl get replicaset`** and count the number of ReplicaSets.
   
   <details>

   ```
   $ kubectl get replicaset (or)
   $ kubectl get rs
   ```
   </details>

1. Run the command **`kubectl get pods`** and count the number of PODs.
   
   <details>

   ```
   $ kubectl get pods
   ```
   </details>

1. Run the command **`kubectl get deployment`** and count the number of PODs.
   
   <details>

   ```
   $ kubectl get deployment
   ```
   </details>

1. Run the command **`kubectl describe deployment`** and look under the containers section.

   <details>

   ```
   $ kubectl describe deployment
   ```
   </details>

   Another way
   
   <details>

   ```
   $ kubectl get deployment -o wide
   ```
   </details>

1. Run the command **`kubectl describe pods`** and look under the events section.

   <details>

   ```
   $ kubectl describe pods
   ```
   </details>

1. Run the command **`kubectl describe pods`** and look under the events section.
   
   <details>

   ```
   $ kubectl describe pods
   ```
   </details>

1. The value for **`kind`** is incorrect. It should be **`Deployment`** with a capital **`D`**. Update the deployment definition and create the deployment.

   <details>

   ```
   $ kubectl create -f deployment-definition-1.yaml
   ```
   </details>

1. Run the command below command
 
   <details>

   ```
   $ kubectl create deployment httpd-frontend --image=httpd:2.4-alpine 
   $ kubectl scale deplyoment httpd-frontend --replicas=3
   ```
   </details>


#### Take me to [Deployment Practice Test - Solutions](https://kodekloud.com/courses/539883/lectures/16416761) 
