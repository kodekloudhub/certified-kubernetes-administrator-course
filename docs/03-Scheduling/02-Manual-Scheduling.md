# Manual Scheduling
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9815303)
  
In this section, we will take a look at **`Manually Scheduling`** a **`POD`** on a node.

## How Scheduling Works
- What do you do when you do not have a scheduler in your cluster?
  - You probably do not want to rely on the built in scheduler and instead want to schedule the PODs yourself.
  - Every POD has a field called NodeName that by default is not set. You don't typically specify this field when you create the manifest file, kubernetes adds it automatically.
  - The scheduler goes throught all the pods and looks for those that do not have this property set. Those are the candidates for scheduling. It then identifies the right node for the POD, by running the scheduling algorithm.
  - Once identified it schedules the POD on the node by setting the nodeName property to the name of the node by creating a binding object.
    ```
    apiVersion: v1
    kind: Pod
    metadata:
     name: nginx
     labels:
      name: nginx
    spec:
     containers:
     - name: nginx
       image: nginx
       ports:
       - containerPort: 8080
     nodeName: node02
    ```
    ![sc1](../../images/sc1.png)
    
## No Scheduler
  - So, if there is no scheduler to monitor and schedule nodes, what happens? The pods continue to be in a pending state. 
  - You can manually assign pods to node itself. Well without a scheduler, to schedule pod is to set **`nodeName`** property in your pod defination file while creating a pod.
    
    ![sc2](../../images/sc2.PNG)
    
  - Another way to assign a node to an existing pod is to create a binding object and send a post request to the pod binding API. In the binding object you specify a target node with the name of the node.
    ```
    apiVersion: v1
    kind: Binding
    metadata:
      name: nginx
    target:
      apiVersion: v1
      kind: Node
      name: node02
    ```
    ```
    apiVersion: v1
    kind: Pod
    metadata:
     name: nginx
     labels:
      name: nginx
    spec:
     containers:
     - name: nginx
       image: nginx
       ports:
       - containerPort: 8080
    ```
    ![sc3](../../images/sc3.PNG)
    
    
K8s Reference Docs:
- https://kubernetes.io/docs/reference/using-api/api-concepts/
- https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodename
    
    
   
