# Practice Test - KubeConfig
  - Take me to [Video Tutorial](https://kodekloud.com/courses/539883/lectures/9816668)
 
Solutions to the practice test - kubeconfig
- Look for the kube config file under /root/.kube
  
  <details>
  ```
  $ ls -l /root/.kube
  ```
  </details>
    
- Run the kubectl config view command and count the number of clusters

  <details>
  ```
  $ kubectl config view
  ```
  </details>
    
- Run the command 'kubectl config view' and count the number of users

  <details>
  ```
  $ kubectl config view
  ```
  </details>
  
- How many contexts are defined in the default kubeconfig file?
  
  <details>
  ```
  $ kubectl config view
  ```
  </details>
  
- Run the command 'kubectl config view' and look for the user name.
  
  <details>
  ```
  $ kubectl config view
  ```
  </details>
  
- What is the name of the cluster configured in the default kubeconfig file?
  
  <details>
  ```
  $ kubectl config view
  ```
  </details>
  
- Run the command 'kubectl config view --kubeconfig my-kube-config'
  
  <details>
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
  </details>
  
- How many contexts are configured in the 'my-kube-config' file?
  
  <details>
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
  </details>
  
- What user is configured in the 'research' context?
  
  <details>
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
  </details>
    
- What is the name of the client-certificate file configured for the 'aws-user'?
  
  <details>
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
  </details>
  
- What is the current context set to in the 'my-kube-config' file?
  
  <details>
  ```
  $ kubectl config view --kubeconfig my-kube-config
  ```
  </details>
  
- Run the command kubectl config --kubeconfig=/root/my-kube-config use-context research
  
  <details>
  ```
  $ kubectl config --kubeconfig=/root/my-kube-config use-context research
  ```
  </details>
  
- Replace the contents in the default kubeconfig file with the content from my-kube-config file.
  
  <details>
  ```
  $ mv .kube/config .kube/config.bak
  $ cp /root/my-kube-config .kube/config
  ```
  </details>
  
- The path to certificate is incorrect in the kubeconfig file. Fix it. All users certificates are stored at /etc/kubernetes/pki/users
  
 <details>
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
 </details>








 
