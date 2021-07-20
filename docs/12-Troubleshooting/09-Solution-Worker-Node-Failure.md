# Solution Worker Node Failure

  - Lets have a look at the [Practice Test](https://kodekloud.com/topic/practice-test-worker-node-failure/) of the Worker Node Failure

    ### Solution

    1. Check Solution 

       <details>

        ```
        ssh node01

        service kubelet start
        ```
        </details>

    2. Check Solution
      
       <details>

        ```
        sed -i 's/WRONG-CA-FILE.crt/ca.crt/g' /var/lib/kubelet/config.yaml
        ```
       </details>

    3. Check Solution
      
       <details>

        ```
        sed -i 's/6553/6443/g' /etc/kubernetes/kubelet.conf
        ```
       </details>