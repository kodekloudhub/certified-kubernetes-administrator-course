# Practice Test - Network Policies
  - Take me to [Practice Test](https://kodekloud.com/courses/539883/lectures/9816676)

Solutions to practice test - network policies
- Run the command 'kubectl get networkpolicy'
  ```
  $ kubectl get networkpolicy
  ```
- Run the command 'kubectl get networkpolicy'
  ```
  $ kubectl get networkpolicy
  ```
- Run the command 'kubectl get networkpolicy' and look under pod selector
  ```
  $ kubectl get networkpolicy
  ```
- Run the command 'kubectl describe networkpolicy' and look under PolicyTypes
  ```
  $ kubectl describe networkpolicy
  ```
- What is the impact of the rule configured on this Network Policy?
  ```
  Traffic from internal to payroll pod is blocked
  ```
- What is the impact of the rule configured on this Network Policy?
  ```
  Internal pod can access port 8080 on payroll pod
  ```
- Access the UI of these applications using the link given above the terminal.

- Only internal applications can access payroll service

- Perform a connectivity test using the User Interface of the Internal Application to access the 'external-service' at port '8080'.
  ```
  Successful
  ```
- Answer file located at /var/answers/answer-internal-policy.yaml
  ```
  $ kubectl create -f /var/answers/answer-internal-policy.yaml
  ```
  
