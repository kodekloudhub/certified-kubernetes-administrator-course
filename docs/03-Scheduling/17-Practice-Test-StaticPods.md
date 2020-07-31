# Practice Test - Static Pods
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/10352436)
  
Solutions to the practice test - static pods
- Run the command kubectl get pods --all-namespaces and look for those with -master appended in the name
  ```
  $ kubectl get pods --all-namespaces
  ```
- Which of the below components is NOT deployed as a static pod?
  ```
  $ kubectl get pods --all-namespaces
  ```
- Which of the below components is NOT deployed as a static POD?
  ```
  $ kubectl get pods --all-namespaces
  ```
- Run the kubectl get pods --all-namespaces -o wide
  ```
  $ kubectl get pods --all-namespaces -o wide
  ```
- Run the command ps -aux | grep kubelet and identify the config file - --config=/var/lib/kubelet/config.yaml. Then checkin the config file for staticPdPath.
  ```
  $ ps -aux | grep kubelet
  ```
- Count the number of files under /etc/kubernetes/manifests

- Check the image defined in the /etc/kubernetes/manifests/kube-apiserver.yaml manifest file.

- Create a pod definition file in the manifests folder. Use command kubectl run --restart=Never --image=busybox static-busybox --dry-run -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
  ```
  $ kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
  ```
- Simply edit the static pod definition file and save it 
  ```
  /etc/kubernetes/manifests/static-busybox.yaml
  ```
  OR
  ```
  Run the command with updated image tag:
  kubectl run --restart=Never --image=busybox:1.28.4 static-busybox--dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
  ```
- Identify which node the static pod is created on, ssh to the node and delete the pod definition file. If you don't know theIP of the node, run the kubectl get nodes -o wide command and identify the IP. Then SSH to the node using that IP. For static pod manifest path look at the file /var/lib/kubelet/config.yaml on node01
  ```
  $ kubectl get pods -o wide
  $ kubectl get nodes -o wide
  $ ssh <ip address of pod>
  $ grep staticPodPath /var/lib/kubelet/config.yaml
  $ node01 $ rm -rf /etc/just-to-mess-with-you/greenbox.yaml
  ```
  
  
 












