# Solution Control Plane Failure

  - Lets have a look at the [Practice Test](https://kodekloud.com/topic/practice-test-control-plane-failure/) of the Control Plane Failure

    ### Solution

    1. Check Solution 

       <details>

        ```
        kubectl get pods -n kube-system
        ```

        ```
        sed -i 's/kube-schedulerrrr/kube-scheduler/g' /etc/kubernetes/manifests/kube-scheduler.yaml
        ```
       </details>

    2. Check Solution

       <details>

        ```
        kubectl scale deploy app --replicas=2
        ```
       </details>

    3. Check Solution

       <details>

        ```
        sed -i 's/controller-manager-XXXX.conf/controller-manager.conf/' /etc/kubernetes/manifests/kube-controller-manager.yaml
        ```
       </details>

    4. Check Solution

       <details>

        ```
        sed -i 's/WRONG-PKI-DIRECTORY/pki/' /etc/kubernetes/manifests/kube-controller-manager.yaml
        ```
       </details>




       