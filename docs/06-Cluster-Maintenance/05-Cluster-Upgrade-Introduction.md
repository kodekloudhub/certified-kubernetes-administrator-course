# Cluster Upgrade Introduction
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808227)
  
#### Is it mandatory for all of the kubernetes components to have the same versions?
- No, The components can be at different release versions.
- Since, the kube-apiserver is the primary component in the control plane and that is the component that all other components talk to, none of the other components should ever be at a version higher than the kube-apiserver.
- The controller manager and Scheduler can be at one version lower (X -1 ).
- Kubelet and Kube-Proxy components can be at 2 versions lower  ( X-2 ).
- kubectl utility could be at a version higher than the apiserver(X+1), the same version as the apiserver, or at version lower than the apiserver (X-1)

  ![up1](../../images/up1.PNG)
  
#### At any time, kubernets supports only up to the recent 3 minor versions
- The recommended approach is to upgrade one minor version at a time.
  
  ![up2](../../images/up2.PNG)
  
#### Options to upgrade k8s cluster
 
  ![opt](../../images/opt.PNG)
  
## Upgrading a Cluster
- Upgrading a cluster involves 2 major steps
  - First, you upgrade your master nodes. Components in the master nodes will go down briefly during upgrade. All workloads hosted on the worker nodes continue to serve users as normal.
  - Then you upgrade the worker nodes.
  
#### There are different strategies that are available to upgrade the worker nodes
- One is to upgrade all at once. But then your pods will be down and users will not be able to access the applications.
  ![stg1](../../images/stg1.PNG)
- Second one is to upgrade one node at a time. 
  ![stg2](../../images/stg2.PNG)
- Third one would be to add new nodes to the cluster
  ![stg3](../../images/stg3.PNG)
  
#### kubeadm - Upgrade


  
  
  
  
