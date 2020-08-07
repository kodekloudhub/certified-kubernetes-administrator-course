# Practice Test - KubeConfig
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9816668)
 
Solutions to the practice test - kubeconfig
- Look for the kube config file under /root/.kube
  ```
  $ ls -l /root/.kube
  ```
- Run the kubectl config view command and count the number of clusters
  ```
  $ kubectl config view
  ```
- Run the command 'kubectl config view' and count the number of users
  ```
  $ kubectl config view
  ```
- How many contexts are defined in the default kubeconfig file?
  ```
  $ kubectl config view
  ```
- Run the command 'kubectl config view' and look for the user name.
  ```
  $ kubectl config view
  ```
- What is the name of the cluster configured in the default kubeconfig file?
  ```
  $ kubectl config view
  ```
- Run the command 'kubectl config view --kubeconfig my-kube-config'
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
- How many contexts are configured in the 'my-kube-config' file?
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
- What user is configured in the 'research' context?
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
- What is the name of the client-certificate file configured for the 'aws-user'?
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
- What is the current context set to in the 'my-kube-config' file?
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
- Run the command kubectl config --kubeconfig=/root/my-kube-config use-context research
  ```
  $ kubectl config --kubeconfig=/root/my-kube-config use-context research
  ```
- Replace the contents in the default kubeconfig file with the content from my-kube-config file.
  ```
  $ mv .kube/config .kube/config.bak
  $ cp /root/my-kube-config .kube/config
  ```
- The path to certificate is incorrect in the kubeconfig file. Fix it. All users certificates are stored at /etc/kubernetes/pki/users
  ```
  $ kubectl get pods
  master $ ls
  dev-user.crt  dev-user.csr  dev-user.key
  master $ vi /root/.kube/config
  master $ grep dev-user.crt /root/.kube/config
    client-certificate: /etc/kubernetes/pki/users/dev-user/dev-user.crt
  master $ pwd
  /etc/kubernetes/pki/users/dev-user
  master $ kubectl get pods
  No resources found in default namespace.
  ```








 
