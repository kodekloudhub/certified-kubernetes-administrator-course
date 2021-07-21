# Practice Test - Certificates API
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-certificates-api/)

Solutions to the practice test - certificate API
- A new member akshay joined our team. He requires access to our cluster. The Certificate Signing Request is at the /root location.

  <details>
  ```
  $ ls -l /root
  ```
  </details>
  
- View the answer at /var/answers/akshay-csr.yaml
  
  <details>
  ```
  $ kubectl create -f /var/answers/akshay-csr.yaml
  ```
  </details>
  
- Run the command kubectl get csr
  
  <details>
  ```
  $ kubectl get csr
  ```
  </details>
    
- Run the command kubectl certificate approve akshay
  
  <details>
  ```
  $ kubectl certificate approve akshay
  ```
  </details>
  
- Run the command kubectl get csr
  
  <details>
  ```
  $ kubectl get csr
  ```
  </details>
  
- Run the command kubectl get csr and look at the Requestor column
  
  <details>
  ```
  $ kubectl get csr
  ```
  </details>
  
- The other CSR's are requested during the TLS Bootstrapping process. We will discuss more about it later in the course when we go through the TLS bootstrap section.

- Run the command kubectl get csr
  
  <details>
  ```
  $ kubectl get csr
  ```
  </details>
  
- Run the command kubectl get csr agent-smith -o yaml
  
  <details>
  ```
  $ kubectl get csr agent-smith -o yaml
  ```
  </details>
  
- Run the command kubectl certificate deny agent-smith
  
  <details>
  ```
  $ kubectl certificate deny agent-smith
  ```
  </details>
  
- Run the command kubectl delete csr agent-smith
  
  <details>
  ```
  $ kubectl delete csr agent-smith
  ```
  </details>
  
