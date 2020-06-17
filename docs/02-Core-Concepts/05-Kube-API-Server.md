# Kube API Server
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808163)
  
In this section, we will talk about kube-apiserver in kubernetes

#### Kube-apiserver is the primary component in kubernetes.
- Kube-apiserver is responsible for **`authenticating`**, **`validating`** requests, **`retrieving`** and **`Updating`** data in ETCD key-value store. In fact kube-apiserver is the only component that interacts directly to the etcd datastore. The other components such as kube-scheduler, kube-controller-manager and kubelet uses the API-Server to update in the cluster in thier respective areas.
- When you run **`kubectl`** command, the kubectl command is in infact reaching the **`kube-apiserver`** 
- kube-apiserver first authenticates the request and validates it.
- Then retrives the data from etcd cluster and responds back with the requested information.
- You don't really need **`kubectl`** command line, instead you could also invoke API directly by sending a **`POST`** request. Lets take a look at an example to create a pod.
  1. Authenticate User
  1. Validate Request
  1. Retrieve Data
  1. Update ETCD
  1. Scheduler
  1. Kubelet
  
  ![post](../../images/post.PNG)
