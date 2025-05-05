# Practice Test - Node Affinity
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-node-affinity-2/)

Solutions to practice test - node affinity

1.  <details>
    <summary>How many Labels exist on node node01?</summary>

    ```
    kubectl describe node node01
    ```

    Look under `Labels` section

    --- OR ---

    ```
    kubectl get node node01 --show-labels
    ```

    </details>

1.  <details>
    <summary>What is the value set to the label key beta.kubernetes.io/arch on node01?</summary>

    From the output of Q1, find the answer there.
    </details>

1.  <details>
    <summary>Apply a label color=blue to node node01</summary>

    ```
    kubectl label node node01 color=blue
    ```
    </details>

1.  <details>
    <summary>Create a new deployment named blue with the nginx image and 3 replicas.</summary>

    ```
    kubectl create deployment blue --image=nginx --replicas=3
    ```
    </details>

1.  <details>
    <summary>Which nodes can the pods for the blue deployment be placed on?</summary>


    Check if master and node01 have any taints on them that will prevent the pods to be scheduled on them. If there are no taints, the pods can be scheduled on either node.

    ```
    kubectl describe nodes controlplane | grep -i taints
    kubectl describe nodes node01 | grep -i taints
    ```
    </details>

1.  <details>
    <summary>Set Node Affinity to the deployment to place the pods on node01 only.</summary>
    Now we edit in place the deployment we created earlier. Remember that we labelled `node01` with `color=blue`? Now we are going to create an affinity to that label, which will "attract" the pods of the deployment to it.

    1.
        ```
        $ kubectl edit deployment blue
        ```
    1. Add the YAML below under the template.spec section, i.e. at the same level as `containers` as it is a POD setting. The affinity will be considered only during scheduling stage, however this edit will cause the deployment to roll out again.

      ```yaml
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: color
                  operator: In
                  values:
                  - blue
      ```
    </details>

1. <details>
    <summary>Which nodes are the pods placed on now?</summary>

    ```
    $ kubectl get pods -o wide
    ```
    </details>

1.  <details>
    <summary>Create a new deployment named red with the nginx image and 2 replicas, and ensure it gets placed on the controlplane node only.</summary>

    1. Create a YAML template for the deploymemt

        ```
        kubectl create deployment red --image nginx --replicas 2 --dry-run=client -o yaml > red.yaml
        ```
    1. Edit the file
        ```
        vi red.yaml
        ```
    1.  Add the toleration using the label stated in the question, and placing it as before for the `blue` deployment
      ```yaml
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: node-role.kubernetes.io/control-plane
                  operator: Exists
      ```
    1. Save, exit and create the deployment
      ```
      kubectl create -f red.yaml
      ```
    1. Check the result
      ```
      $ kubectl get pods -o wide
      ```
    </details>



