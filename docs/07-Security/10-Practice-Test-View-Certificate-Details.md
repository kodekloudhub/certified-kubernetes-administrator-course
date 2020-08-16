# Practice Test - View Certificates
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816665)
  
Solutions to practice test - view certificates
- Identify the certificate file used for the kube-api server
  
  <details>
  
  ```
  $ cat /etc/kubernetes/manifest/kube-apiserver.yaml
  
  Answer: /etc/kubernetes/pki/apiserver.crt
  ```
  </details>
  
- Identify the Certificate file used to authenticate kube-apiserver as a client to ETCD Server
  
  <details>
  ```
  $ cat /etc/kubernetes/manifest/kube-apiserver.yaml
  Answer: /etc/kubernetes/pki/apiserver-etcd-client.crt
  ```
  </details>
  
- Look for kubelet-client-key option in the file /etc/kubernetes/manifests/kube-apiserver.yaml
  
  <details>
  ```
  Answer: /etc/kubernetes/pki/apiserver-kubelet-client.key
  ```
  </details>
  
- Look for cert file option in the file /etc/kubernetes/manifests/etcd.yaml
  
  <details>
  ```
  Answer: /etc/kubernetes/pki/etcd/server.crt
  ```
  </details>
  
- Look for CA Certificate in file /etc/kubernetes/manifests/etcd.yaml
  
  <details>
  ```
  Answer: /etc/kubernetes/pki/etcd/ca.crt
  ```
  </details>
  
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  
  <details>
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
  </details>
  
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and look for issuer
  
  <details>
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text 
  ```
  </details>
  
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and look at Alternative Names
  
  <details>
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
  </details>
  
- Run the command openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text and look for Subject CN.
  
  <details>
  ```
  $ openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text
  ```
  </details>
  
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and check on the Expiry date.
  
  <details>
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
  </details>
  
- Run the command 'openssl x509 -in /etc/kubernetes/pki/ca.crt -text' and look for validity
  
  <details>
  ```
  $ openssl x509 -in /etc/kubernetes/pki/ca.crt -text
  ```
  </details>
  
- Inspect the --cert-file option in the manifests file.
  
  <details>
  ```
  $ vi /etc/kubernetes/manifests/etcd.yaml
  ```
  </details>
  
- ETCD has its own CA. The right CA must be used for the ETCD-CA file in /etc/kubernetes/manifests/kube-apiserver.yaml. 
  
  <details>
  ```
  View answer at /var/answers/kube-apiserver.yaml
  ```
  </details>






  
