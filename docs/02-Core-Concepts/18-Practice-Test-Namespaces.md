# Practice Test - Namespaces
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816576)

Solutions to practice test for namespaces

1. Run the command **`kubectl get namespace`** and count the number of pods.
   ```
   $ kubectl get namespace
   ```
1. Run the command **`kubectl get pods --namespace=research`**
   ```
   $ kubectl get pods --namespace=research
   ```
1. Run the below command
   ```
   $ kubectl run redis --image=redis --namespace=finance
   ```
1. Run the command **`kubectl get pods --all-namespaces`**
   ```
   $ kubectl get pods --all-namespaces
   ```
1. Connectivity Test
   ```
   Host Name: db-service and Host Port: 3306
   ```
1. Connectivity Test
   ```
   Host Name: db-service.dev.svc.cluster.local and Host Port: 3306
   ```

Take me to [Practice Test Solutions](https://kodekloud.com/courses/539883/lectures/16416900)
