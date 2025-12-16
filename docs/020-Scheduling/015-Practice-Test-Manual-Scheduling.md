# Practice Test - Manual Scheduling
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-manual-scheduling/)

Solutions to Practice Test - Manual Scheduling

1.  <details>
    <summary>A pod definition file nginx.yaml is given. Create a pod using the file.</summary>

    ```
    kubectl create -f nginx.yaml
    ```
    </details>

1.  <details>
    <summary>What is the status of the created POD?</summary>

    ```
    kubectl get pods
    ```

    Examine the `STATUS` column
    </details>

1.  <details>
    <summary>Why is the POD in a pending state?</br>Inspect the environment for various kubernetes control plane components.</summary>

    ```
    kubectl get pods --namespace kube-system
    ```

    There is a key pod missing here!
    </details>

1.  <details>
    <summary>Manually schedule the pod on node01.</summary>

    We will have to delete and recereate the pod, as the only property that may be edited on a running container is `image`

    ```
    vi nginx.yaml
    ```

    Make the following edit

    ```yaml
    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx
    spec:
      nodeName: node01    # add this line
      containers:
      -  image: nginx
         name: nginx
    ```

    ```
    kubectl delete -f nginx.yaml
    kubectl create -f nginx.yaml
    ```
    </details>

1.  <details>
    <summary>Now schedule the same pod on the controlplane node.</summary>

    Repeat the steps as per the previous question. Edit `nodeName` to be `controlplane`
  </details>

