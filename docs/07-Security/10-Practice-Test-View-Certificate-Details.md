# Practice Test - View Certificates
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816665)
  
Solutions to practice test - view certificates
- Identify the certificate file used for the kube-api server
  ```
  $ cat /etc/kubernetes/manifest/kube-apiserver.yaml
  
  Answer: /etc/kubernetes/pki/apiserver.crt
  ```
- Identify the Certificate file used to authenticate kube-apiserver as a client to ETCD Server
  ```
  $ cat /etc/kubernetes/manifest/kube-apiserver.yaml
  
  Answer: /etc/kubernetes/pki/apiserver-etcd-client.crt
  ```
- Look for kubelet-client-key option in the file /etc/kubernetes/manifests/kube-apiserver.yaml
  ```
  Answer: /etc/kubernetes/pki/apiserver-kubelet-client.key
  ```
- Look for cert file option in the file /etc/kubernetes/manifests/etcd.yaml
  ```
  Answer: /etc/kubernetes/pki/etcd/server.crt
  ```
- Look for CA Certificate in file /etc/kubernetes/manifests/etcd.yaml
  ```
  Answer: /etc/kubernetes/pki/etcd/ca.crt
  ```
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and look for issuer
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text 
  ```
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and look at Alternative Names
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
- Run the command openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text and look for Subject CN.
  ```
  $ openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text
  ```
- Run the command openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and check on the Expiry date.
  ```
  $ openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
  ```
- Run the command 'openssl x509 -in /etc/kubernetes/pki/ca.crt -text' and look for validity
  ```
  $ openssl x509 -in /etc/kubernetes/pki/ca.crt -text
  ```
- Inspect the --cert-file option in the manifests file.
  ```
  $ vi /etc/kubernetes/manifests/etcd.yaml
  ```
- ETCD has its own CA. The right CA must be used for the ETCD-CA file in /etc/kubernetes/manifests/kube-apiserver.yaml. 
  ```
  View answer at /var/answers/kube-apiserver.yaml
  ```






  
