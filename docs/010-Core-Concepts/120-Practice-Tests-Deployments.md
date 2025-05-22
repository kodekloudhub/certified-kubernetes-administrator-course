# Practice Test - Deployments
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-tests-deployments/)

Solutions to the deployments practice test
1. <details>
   <summary>How many pods exist on the system?</summary>

   ```bash
   kubectl get pods
   ```

   Count the number of pods (if any)

   </details>

1. <details>
   <summary>How many ReplicaSets exist on the system?</summary>

   ```bash
   kubectl get replicasets
   ```

   Count the number of ReplicaSets  (if any)

   </details>

1. <details>
   <summary>How many Deployments exist on the system?</summary>

   ```bash
   kubectl get deployments
   ```

   Count the number of Deployments  (if any)

   </details>

1. <details>
   <summary>How many Deployments exist on the system now?</summary>

   ```bash
   kubectl get deployments
   ```

   Count the number of Deployments  (if any)

   </details>

1. <details>
   <summary>How many ReplicaSets exist on the system now?</summary>

   ```bash
   kubectl get replicasets
   ```

   Count the number of ReplicaSets  (if any)

   </details>

1. <details>
   <summary>How many Pods exist on the system?</summary>

   ```bash
   kubectl get pods
   ```

   Count the number of pods  (if any)

   </details>

1. <details>
   <summary>Out of all the existing PODs, how many are ready?</summary>

   From the output of the previous command, check the `READY` column
   </details>

1. <details>
   <summary>What is the image used to create the pods in the new deployment?</summary>

   ```
   kubectl describe deployment
   ```

   Look under the containers section.

   Another way - run the following and check the `IMAGES` column

   ```
   kubectl get deployment -o wide
   ```
   </details>

1. <details>
   <summary>Why do you think the deployment is not ready?</summary>

   ```
   kubectl describe pods
   ```

   Look under the events section.
   </details>

1. <details>
   <summary>Create a new Deployment using the deployment-definition-1.yaml file located at /root/.</br>There is an issue with the file, so try to fix it.</summary>

   ```
   kubectl create -f deployment-definition-1.yaml
   ```

   Note the error

   Edit the file with `vi`...

   The value for **`kind`** is incorrect. It should be **`Deployment`** with a capital **`D`**. Update the deployment definition and create the deployment with the above command.

   </details>

1. <details>
   <summary>Create a new Deployment with the below attributes using your own deployment definition file.</summary>

   Create a deployment definition file in `vi`, e.g. `my-deployment.yaml` with the following

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: httpd-frontend
      name: httpd-frontend
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: httpd-frontend
      template:
        metadata:
          labels:
            app: httpd-frontend
        spec:
          containers:
          - image: httpd:2.4-alpine
            name: httpd
    ```

   ```
   kubectl create -f my-deployment.yaml
   ```

   Or we could create it imperatively...

   ```
   kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=3
   ```
   </details>

