# Practice Test - Labels and Selectors
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-labels-and-selectors/)

Solutions to Practice Test - Labels and Selectors
1.  <details>
    <summary>We have deployed a number of PODs. They are labelled with tier, env and bu. How many PODs exist in the dev environment (env)?</summary>

    Here we are filtering pods by the value olf a label

    ```
    kubectl get pods --selector env=dev
    ```

    Count the pods (if any)

    </details>

1.  <details>
    <summary>How many PODs are in the finance business unit (bu)?</summary>

    Similarly ...

    ```
    kubectl get pods --selector bu=finance
    ```

    Count the pods (if any)
    </details>

1.  <details>
    <summary>How many objects are in the prod environment including PODs, ReplicaSets and any other objects?</summary>

    ```
    kubectl get all --selector env=prod
    ```

    Count everything (if anything)
    </details>

1.  <details>
    <summary>Identify the POD which is part of the prod environment, the finance BU and of frontend tier?</summary>

    We can combine label expressions with comma. Only items with _all_ the given label/value pairs will be returned, i.e. it is an `and` condition.

    ```
    kubectl get all --selector env=prod,bu=finance,tier=frontend
    ```
    </details>

1. <details>
   <summary>A ReplicaSet definition file is given replicaset-definition-1.yaml. Try to create the replicaset. There is an issue with the file. Try to fix it.</summary>

   ```
   kubectl create -f replicaset-definition-1.yaml
   ```

   Note the error message.

   Selector matchLabels should match with POD labels - Update `replicaset-definition-2.yaml`

   The values for labels on lines 9 and 13 should match.

   ```
   $ kubectl create -f replicaset-definition-2.yaml
   ```
   </details>

