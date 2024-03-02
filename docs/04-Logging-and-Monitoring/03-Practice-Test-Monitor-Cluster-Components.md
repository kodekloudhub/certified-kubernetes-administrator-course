# Practice Test - Monitor Cluster Components
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-monitor-cluster-components/)
  
Solutions to practice test - monitor cluster components
1.  <details>
    <summary>We have deployed a few PODs running workloads. Inspect it.</summary>

    ```
    kubectl get pods
    ```
    </details>
  
1.  <details>
    <summary>Let us deploy metrics-server to monitor the PODs and Nodes. Pull the git repository for the deployment files.</summary>

    ```
    git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
    ```
    </details>
  
1.  <details>
    <summary>Deploy the metrics-server by creating all the components downloaded.</summary>
    
    Run the 'kubectl create -f .' command from within the downloaded repository.
  
    ```
    cd kubernetes-metrics-server
    kubectl create -f .
    ```
    </details>
    
1.  <details>
    <summary>It takes a few minutes for the metrics server to start gathering data.</summary>

    Run the `kubectl top node` command and wait for a valid output.
    
    ```
    kubectl top node
    ```
    </details>
  
1.  <details>
    <summary>Identify the node that consumes the most CPU(cores).</summary>

     Run the `kubectl top node` command

      ```
      kubectl top node
      ```

      Examine the `CPU(cores)` column of the output to get the answer.

      </details>
  
1.  <details>
    <summary>Identify the node that consumes the most Memory(bytes).</summary>
    Run the `kubectl top node` command
  
    ```
    $ kubectl top node
    ```

    Examine the `MEMORY(bytes)` column of the output to get the answer.

    </details>
  
1.  <details>
    <summary>Identify the POD that consumes the most Memory(bytes).</summary>

    Run the `kubectl top pod` command
  
    ```
    kubectl top pod
    ```

    Examine the `MEMORY(bytes)` column of the output to get the answer.

    </details>
  
1.  <details>

    <summary>Identify the POD that consumes the least CPU(cores).</summary>

    Run the `kubectl top pod` command
  
    ```
    kubectl top pod
    ```

    Examine the `CPU(cores)` column of the output to get the answer.

  </details>
  


