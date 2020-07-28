# Solution Worker Node Failure

  - Lets have a look at the [Solution](https://kodekloud.com/courses/539883/lectures/13195330) of the Worker Node Failure

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