# Practice Test - Certificates API
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816667)

Solutions to the practice test - certificate API
- A new member akshay joined our team. He requires access to our cluster. The Certificate Signing Request is at the /root location.
  ```
  $ ls -l /root
  ```
- View the answer at /var/answers/akshay-csr.yaml
  ```
  $ kubectl create -f /var/answers/akshay-csr.yaml
  ```
- Run the command kubectl get csr
  ```
  $ kubectl get csr
  ```
- Run the command kubectl certificate approve akshay
  ```
  $ kubectl certificate approve akshay
  ```
- Run the command kubectl get csr
  ```
  $ kubectl get csr
  ```
- Run the command kubectl get csr and look at the Requestor column
  ```
  $ kubectl get csr
  ```
- The other CSR's are requested during the TLS Bootstrapping process. We will discuss more about it later in the course when we go through the TLS bootstrap section.

- Run the command kubectl get csr
  ```
  $ kubectl get csr
  ```
- Run the command kubectl get csr agent-smith -o yaml
  ```
  $ kubectl get csr agent-smith -o yaml
  ```
- Run the command kubectl certificate deny agent-smith
  ```
  $ kubectl certificate deny agent-smith
  ```
- Run the command kubectl delete csr agent-smith
  ```
  $ kubectl delete csr agent-smith
  ```
  
