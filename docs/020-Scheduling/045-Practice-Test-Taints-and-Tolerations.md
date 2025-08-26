# Practice Test - Taints and Tolerations
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-taints-and-tolerations/)

Solutions to the Practice Test - Taints and Tolerations

1.  <details>
    <summary>How many nodes exist on the system?</summary>

    ```
    $ kubectl get nodes
    ```

    Count the nodes

    </details>

1.  <details>
    <summary>Do any taints exist on node01 node?</summary>

    ```
    $ kubectl describe node node01
    ```

    Find the `Taints` property in the output.
    </details>

1.  <details>
    <summary>Create a taint on node01 with key of spray, value of mortein and effect of NoSchedule</summary>

    ```
    kubectl taint nodes node01 spray=mortein:NoSchedule
    ```
    </details>

1.  <details>
    <summary>Create a new pod with the nginx image and pod name as mosquito.</summary>

    ```
    kubectl run mosquito --image nginx
    ```
    </details>

1.  <details>
    <summary>What is the state of the POD?</summary>

    ```
    kubectl get pods
    ```

    Check the `STATUS` column
    </details>

1.  <details>
    <summary>Why do you think the pod is in a pending state?</summary>

    Mosqitoes don't like mortein!

    So the answer is that the pod cannot tolerate the taint on the node.

    </details>

1.  <details>
    <summary>Create another pod named bee with the nginx image, which has a toleration set to the taint mortein.</summary>

    Allegedly bees are immune to mortein!

    1.  Create a YAML skeleton for the pod imperatively

        ```
        kubectl run bee --image nginx --dry-run=client -o yaml > bee.yaml
        ```
    1.  Edit the file to add the toleration
        ```
        vi bee.yaml
        ```
    1. Add the toleration. This goes at the same indentation level as `containers` as it is a POD setting.
        ```yaml
          tolerations:
          - key: spray
            value: mortein
            effect: NoSchedule
            operator: Equal
        ```
    1. Save and exit, then create pod
        ```
        kubectl create -f bee.yaml
        ```
    </details>

1. Information only.

1.  <details>
    <summary>Do you see any taints on controlplane node?</summary>

    ```
    kubectl describe node controlplane
    ```

    Examine the `Taints` property.
    </details>

1.  <details>
    <summary>Remove the taint on controlplane, which currently has the taint effect of NoSchedule.</summary>

    ```
    kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-
    ```
    </details>

1.  <details>
    <summary>What is the state of the pod mosquito now?</summary>

    ```
    $ kubectl get pods
    ```
    </details>

1.  <details>
    <summary>Which node is the POD mosquito on now?</summary>

    ```
    $ kubectl get pods -o wide
    ```

    This also explains why the `mosquito` pod colud schedule anywhere. It also could not tolerate `controlplane` taints, which we have now removed.
    </details>


