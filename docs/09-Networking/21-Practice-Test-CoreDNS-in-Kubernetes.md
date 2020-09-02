# Practice Test CoreDNS in Kubernetes

  - Take me to [Lab](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/9816807)

#### Solution 

  1. Check the Solution

     <details>

      ```
      CoreDNS
      ```
     </details>
  
  2. Check the Solution

     <details>

      ```
      2
      ```
     </details>

  3. Check the Solution

     <details>

      ```
      10.96.0.10
      ```
     </details>

  4. Check the Solution

     <details>

      ```
      /etc/coredns/Corefile

      OR

      kubectl -n kube-system describe deployments.apps coredns | grep -A2 Args | grep Corefile
      ```
     </details>

  5. Check the Solution

     <details>

      ```
      Configured as a ConfigMapObject
      ```
     </details>

  6. Check the Solution

     <details>

      ```
      CoreDNS
      ```
     </details>

  7. Check the Solution

     <details>

      ```
      coredns
      ```
     </details>

  8. Check the Solution

     <details>

      ```
      cluster.local
      ```
     </details>

  9. Check the Solution

     <details>

      ```
      Ok
      ```
     </details>

  10. Check the Solution

      <details>

       ```
       web-service
       ```
      </details>

  11. Check the Solution

      <details>
 
       ```
       web-serivce.default.pod
       ```
      </details>

  12. Check the Solution

      <details>
 
       ```
       web-service.payroll
       ```
      </details>

  13. Check the Solution

      <details>
 
       ```
       web-service.payroll.svc.cluster
       ```
      </details>

  14. Check the Solution

      <details>
 
       ```
       kubectl edit deploy webapp
 
       Search for DB_Host and Change the DB_Host from mysql to mysql.payroll
 
       spec:
         containers:
         - env:
           - name: DB_Host
             value: mysql.payroll
       ```
      </details>
 
  15. Check the Solution

      <details>
 
       ```
       kubectl exec -it hr -- nslookup mysql.payroll > /root/nslookup.out
       ```
      </details>