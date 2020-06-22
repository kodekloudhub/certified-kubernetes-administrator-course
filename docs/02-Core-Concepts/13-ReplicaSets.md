# ReplicaSets
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808168)

In this section, we will take a look at replication controllers

#### Controllers are brain behind kubernetes

## What is a Replica and Why do we need a replication controller?
- The Replication Controller helps us run multiple instances of a single pod in a kubernetes cluster thus providing **`high availablility`**.
- Even if you have a single pod, the replication controller can help by automatically bringing up new pod when the existing one fails. Thus the replication controller ensures that the specified number of pods are running at all times, even if it is just 1 or 100.
  ![rc](../../images/rc.PNG)
- Another reason we need replication is to create multiple pods to share the load across them - **`Load Balancing & Scaling`**
  ![rc1](../../images/rc1.PNG).
  
## Difference between ReplicaSet and Replication Controller
- **`Replication Controller`** is the older technology that is being replaced by a **`ReplicaSet`**.
- ReplicaSet is the new way to setup replication.

## Creating a Replication Controller
  
   ![rc2](../../images/rc2.PNG)
   
  - To Create the replication controller
    ```
    $ kubectl create -f rc-defination.yaml
    ```
  - To list all the replication controllers
    ```
    $ kubectl get replicationcontroller
    ```
  - To list pods that are launch by the replication controller
    ```
    $ kubectl get pods
    ```
    
## 
## Creating a ReplicaSet
  
  
  
