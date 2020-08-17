# Practice Test - Network Policies
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816676)

Solutions to practice test - network policies

- Run the command 'kubectl get networkpolicy'
  
  <details>
  
  ```
  $ kubectl get networkpolicy
  ```
  
  </details>
  
- Run the command 'kubectl get networkpolicy'
   
  <details>
  
  ```
  $ kubectl get networkpolicy
  ```
  
  </details>
  
- Run the command 'kubectl get networkpolicy' and look under pod selector
  
  <details>
  
  ```
  $ kubectl get networkpolicy
  ```
  
  </details>
  
- Run the command 'kubectl describe networkpolicy' and look under PolicyTypes
  
  <details>
  
  ```
  $ kubectl describe networkpolicy
  ```
  
  </details>
  
- What is the impact of the rule configured on this Network Policy?
  
  <details>
  
  ```
  Traffic from internal to payroll pod is blocked
  ```
  
  </details>
  
- What is the impact of the rule configured on this Network Policy?
  
  <details>
  
  ```
  Internal pod can access port 8080 on payroll pod
  ```
  
  </details>
  
- Access the UI of these applications using the link given above the terminal.

- Only internal applications can access payroll service

- Perform a connectivity test using the User Interface of the Internal Application to access the 'external-service' at port '8080'.
  
  <details>
  
  ```
  Successful
  ```
  
  </details>
  
- Answer file located at /var/answers/answer-internal-policy.yaml
  
  <details>
  
  ```
  $ kubectl create -f /var/answers/answer-internal-policy.yaml
  ```
  
  </details>
  
  
