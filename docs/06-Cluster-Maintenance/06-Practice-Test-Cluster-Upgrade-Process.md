# Practice Test - Cluster Upgrade Process
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816651)
  
Solutions to practice test cluster upgrade process
- What is the current version of the cluster?
  ```
  $ kubectl get nodes
  ```
- How many nodes are part of this cluster?
  ```
  $ kubctl get nodes
  ```
- Check what nodes the pods are hosted on.
  ```
  $ kubectl get pods -o wide
  ```
- Count the number of deployments
  ```
  $ kubectl get deploy
  ```
- Run the command kubectl get pods -o wide
  ```
  $ kubectl get pods -o wide
  ```
- You are tasked to upgrade the cluster. User's accessing the applications must not be impacted. And you cannot provision new VMs. What strategy would you use to upgrade the cluster?
  ```
  Upgrade one node at a time while moving the workloads to the other
  ```
- Run the kubeadm upgrade plan command
  ```
  $ kubeadm upgrade plan
  ```
- Run the kubectl drain master --ignore-daemonsets
  ```
  $ kubectl drain master --ignore-daemonsets
  ```
- Run the command apt install kubeadm=1.18.0-00 and then kubeadm upgrade apply v1.18.0 and then apt install kubelet=1.18.0-00 to upgrade the kubelet on the master node
  ```
  $ apt install kubeadm=1.18.0-00
  $ kubeadm upgrade apply v1.18.0 
  $ apt install kubelet=1.18.0-00
  ```
- Run the command kubectl uncordon master
  ```
  $ kubectl uncordon master 
  ```
- Run the command kubectl drain node01 --ignore-daemonsets
  ```
  $ kubectl drain node01 --ignore-daemonsets
  ```
- Run the commands: apt install kubeadm=1.18.0-00 and then kubeadm upgrade node. Finally, run apt install kubelet=1.18.0-00.
  ```
  $ apt install kubeadm=1.18.0-00
  $ kubeadm upgrade node
  $ apt install kubelet=1.18.0-00
  ```
- Run the command kubectl uncordon node01
  ```
  $ kubectl uncordon node01
  ```






#### Take me to [Practice Test - Solutions Video Tutorial](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/14468155)
