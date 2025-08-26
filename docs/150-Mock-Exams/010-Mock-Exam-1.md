# Mock Exam 1

  Test My Knowledge, Take me to [Mock Exam 1](https://kodekloud.com/topic/mock-exam-1-3/)

  #### Solution to the Mock Exam 1

  1. Apply below manifests:

     <details>
     
     ```
     apiVersion: v1
     kind: Pod
     metadata:
       creationTimestamp: null
       labels:
         run: nginx-pod
       name: nginx-pod
     spec:
       containers:
       - image: nginx:alpine
         name: nginx-pod
         resources: {}
       dnsPolicy: ClusterFirst
       restartPolicy: Always
     status: {}
     ```
     </details>

  2. Run below command which create a pod with labels:

     <details>
     
     ```
     kubectl run messaging --image=redis:alpine --labels=tier=msg
     ```
     </details>

 
  3. Run below command to create a namespace:
     
     <details>

     ```
     kubectl create namespace apx-x9984574
     ```
     </details>

  4. Use the below command which will redirect the o/p:

     <details>

     ```
     kubectl get nodes -o json > /opt/outputs/nodes-z3444kd9.json
     ```
     </details>

  5. Execute below command which will expose the pod on port 6379:

     <details>

     ```
     kubectl expose pod messaging --port=6379 --name messaging-service
     ```
     </details>

  6. Apply below manifests:

     <details>

      ```
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        creationTimestamp: null
        labels:
          app: hr-web-app
        name: hr-web-app
      spec:
        replicas: 2
        selector:
          matchLabels:
            app: hr-web-app
        strategy: {}
        template:
          metadata:
            creationTimestamp: null
            labels:
              app: hr-web-app
          spec:
            containers:
            - image: kodekloud/webapp-color
              name: webapp-color
              resources: {}
      status: {}
      ```
      
      In v1.19, we can add `--replicas` flag with `kubectl create deployment` command:
      ```
      kubectl create deployment hr-web-app --image=kodekloud/webapp-color --replicas=2
      ```
     </details>

  7. To Create a static pod, copy it to the static pods directory. In this case, it is `/etc/kubernetes/manifests`. Apply below manifests:

     <details>

     ```
     apiVersion: v1
     kind: Pod
     metadata:
       creationTimestamp: null
       labels:
         run: static-busybox
       name: static-busybox
     spec:
       containers:
       - command:
         - sleep
         - "1000"
         image: busybox
         name: static-busybox
         resources: {}
       dnsPolicy: ClusterFirst
       restartPolicy: Always
     status: {}
     ```
     </details>

  8. Run below command to create a pod in namespace `finance`:

     <details>

     ```
     kubectl run temp-bus --image=redis:alpine -n finance
     ```
     </details>

  9. Run below command and troubleshoot step by step:

     <details>

     ```
     kubectl describe pod orange
     ```

     Export the running pod using below command and correct the spelling of the command **`sleeeep`** to **`sleep`** 

     ```
     kubectl get pod orange -o yaml > orange.yaml
     ```
   
     Delete the running Orange pod and recreate the pod using command.
     
     ```
     kubectl delete pod orange
     kubectl create -f orange.yaml
     ```
     </details>

  10. Apply below manifests:

      <details>

      ```
      apiVersion: v1
      kind: Service
      metadata:
        creationTimestamp: null
        labels:
          app: hr-web-app
        name: hr-web-app-service
      spec:
        ports:
        - port: 8080
          protocol: TCP
          targetPort: 8080
          nodePort: 30082
        selector:
          app: hr-web-app
        type: NodePort
      status:
        loadBalancer: {}
      ```
      </details>

  11. Run the below command to redirect the o/p:

      <details>

      ``` 
      kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os_x43kj56.txt
      ```
      </details>

  12. Apply the below manifest to create a PV:

      <details>
     
       ```
       apiVersion: v1
       kind: PersistentVolume
       metadata:
         name: pv-analytics
       spec:
         capacity:
           storage: 100Mi
         volumeMode: Filesystem
         accessModes:
           - ReadWriteMany
         hostPath:
             path: /pv/data-analytics
       ```
       </details>
       
