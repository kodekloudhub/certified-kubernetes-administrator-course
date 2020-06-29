# Kube Scheduler
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9808162)

In this section, we will take a look at kube-scheduler.

#### kube-scheduler is responsible for scheduling pods on nodes.  
- The kube-scheduler is only responsible for deciding which pod goes on which node. It doesn't actually place the pod on the nodes, thats the job of the **`kubelet`**.
- The kubelet will create the pods on the nodes, the scheduler only decides which pods goes where.
  
  ![kube-scheduler1](../../images/kube-scheduler1.PNG)
  
#### Why do you need a Scheduler?
- There are many nodes and many containers, want to make sure that the right container ends up on the right node.
- The scheduler goes through 2 phases to identify the best node for the pod.
  - In the first phase, the scheduler filters out the nodes that do not fit for the profile for this pod. For example the nodes that do not have sufficient memory and cpu resources requested by the pod. In this case, the 2 small nodes are filtered out, now we are left with 2 nodes on which the pod can be placed. Now, how does the scheduler pick one from the two? 
  - In the second phase, the scheduler ranks the nodes to identify the best fit for the pod, it uses a priority function to assign a score to the node on a scale of 0 to 10

    ![kube-scheduler2](../../images/kube-scheduler2.PNG)
    
## Install kube-scheduler - Manual
- Download the kubescheduler binary from the kubernetes release pages [kube-scheduler](https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-scheduler). For example: To download kube-scheduler v1.13.0, Run the below command.
  ```
  $ wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-scheduler
  ```
- Extract it
- Run it as a service

  ![kube-scheduler3](../../images/kube-scheduler3.PNG)
  
## View kube-scheduler options - kubeadm
- If you set it up with kubeadm tool, kubeadm tool will deploy the kube-scheduler as pod in kube-system namespace on master node.
  ```
  $ kubectl get pods -n kube-system
  ```
- You can see the options for kube-scheduler in pod defination file that is located at **`/etc/kubernetes/manifests/kube-scheduler.yaml`**
  ```
  $ cat /etc/kubernetes/manifests/kube-scheduler.yaml
  ```
  ![kube-scheduler4](../../images/kube-scheduler4.PNG)
  
- You can also see the running process and affective options by listing the process on master node and searching for kube-apiserver.
  ``` 
  $ ps -aux |grep kube-scheduler
  ```
  ![kube-scheduler5](../../images/kube-scheduler5.PNG)
  
  K8s Reference Docs:
  - https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/
  - https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/
  - https://kubernetes.io/docs/concepts/overview/components/
  - https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/
    
