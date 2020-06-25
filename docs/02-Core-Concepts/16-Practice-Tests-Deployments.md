# Practice Test - Deployments
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816571)
  
Solutions to the deploments practice test
1. Run the command **`kubectl get pods`** and count the number of pods.
   ```
   $ kubectl get pods
   ```
1. Run the command **`kubectl get replicaset`** and count the number of ReplicaSets.
   ```
   $ kubectl get replicaset (or)
   $ kubectl get rs
   ```
1. Run the command **`kubectl get deployment`** and count the number of Deployments.
   ```
   $ kubectl get deployment
   ```

1. Run the command **`kubectl get deployment`** and count the number of Deployments.
   ```
   $ kubectl get deployment
   ```
1. Run the command **`kubectl get replicaset`** and count the number of ReplicaSets.
   ```
   $ kubectl get replicaset (or)
   $ kubectl get rs
   ```
1. Run the command **`kubectl get pods`** and count the number of PODs.
   ```
   $ kubectl get pods
   ```
1. Run the command **`kubectl get deployment`** and count the number of PODs.
   ```
   $ kubectl get deployment
   ```
1. Run the command **`kubectl describe deployment`** and look under the containers section.
   ```
   $ kubectl describe deployment
   ```
   Another way
   ```
   $ kubectl get deployment -o wide
   ```
1. Run the command **`kubectl describe pods`** and look under the events section.
   ```
   $ kubectl describe pods
   ```
1. Run the command **`kubectl describe pods`** and look under the events section.
   ```
   $ kubectl describe pods
   ```
1. The value for **`kind`** is incorrect. It should be **`Deployment`** with a capital **`D`**. Update the deployment defination and create the deployment.
   ```
   $ kubectl create -f deployment-defination-1.yaml
   ```
1. Run the command below command
   ```
   $ kubectl create deployment httpd-frontend --image=httpd:2.4-alpine 
   $ kubectl scale deplyoment httpd-frontend --replicas=3
   ```

Take me to [Deployment Practice Test - Solutions](https://kodekloud.com/courses/539883/lectures/16416761) 
