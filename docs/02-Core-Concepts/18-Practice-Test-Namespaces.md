# Practice Test - Namespaces
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-namespaces/)

Solutions to practice test for namespaces

1. <details>
   <summary>How many Namespaces exist on the system?</summary>

   ```
   kubectl get namespace
   ```

   Count the number of namespaces (if any)
   </details>

1. <details>
   <summary>How many pods exist in the research namespace?</summary>

   ```
   kubectl get pods --namespace=research
   ```

   Count the number of pods (if any)
   </details>

1. <details>
   <summary>Create a POD in the finance namespace.</summary>

   ```
   kubectl run redis --image=redis --namespace=finance
   ```
   </details>

1. <details>
   <summary>Which namespace has the blue pod in it?</summary>

   ```
   kubectl get pods --all-namespaces
   ```

   Examine the output.

   Or use `grep` to filter the results, knowing that `NAMESPACE` is the first result column

   ```
   kubectl get pods --all-namespaces | grep blue
   ```

   </details>

1. <details>
   <summary>Access the Blue web application using the link above your terminal!!</summary>

   Press the `blue-application-ui` button at the top of the terminal. Try the following:

   ```
   Host Name: db-service
   Host Port: 6379
   ```
   </details>

1. <details>
   <summary>What DNS name should the Blue application use to access the database db-service in its own namespace - marketing?</summary>

   > db-service

   To access services in the same namespace, only the host name part of the fully qualified domain name (FQDN) is required.

   </details>

1. <details>
   <summary>What DNS name should the Blue application use to access the database db-service in the dev namespace?</summary>

   Either FQDN

   > db-service.dev.svc.cluster.local

   Or, it is sufficient just to append the namespace name

   > db-service.dev

   </details>

