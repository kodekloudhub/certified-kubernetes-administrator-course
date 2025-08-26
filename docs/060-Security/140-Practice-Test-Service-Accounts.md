# Practice Test - Practice Test Service Accounts
  - Take me to [Practice Test](https://uklabs.kodekloud.com/topic/practice-test-service-accounts-2/)

Solutions to the Practice Test Service Accounts
1.  <details>
    <summary>How many service accounts exist in the default namespace?</summary>

    Run the command `kubectl get serviceaccounts` and count the number of accounts.

    </details>

1.  <details>
    <summary>What is the secret token used by the default service account?</summary>

    Run the command `kubectl describe serviceaccount default` and look at the `Tokens` field.

    > `none`

    </dtails>

1.  <details>
    <summary>We just deployed the Dashboard application.<br/>Inspect the deployment. What is the image used by the deployment?</summary>


    Run the command `kubectl describe deployment` and look at the `Image` field

    > `gcr.io/kodekloud/customimage/my-kubernetes-dashboard`

    </details>

1. Information only.

1.  <details>
    <summary>What is the state of the dashboard? Have the pod details loaded successfully?</summary>

    Open the `web-dashboard` link located above the terminal and inspect the status. We can see an error message, therefore the status is...

    > `Failed`

    </details>

1.  <details>
    <summary>What type of account does the Dashboard application use to query the Kubernetes API?</summary>

    As evident from the error in the web-dashboard UI, the pod makes use of a service account to query the Kubernetes API.

    > Service Account

    </details>

1.  <details>
    <summary>Which account does the Dashboard application use to query the Kubernetes API?</summary>

    To find this, we need to insect the YAML of the running pod. The correct field for specifying a pod's service account is `serviceAccountName`. To save looking at _all_ the YAML, we can use `grep` command to extract only that field:

    ```
    kubectl get po -o yaml | grep 'serviceAccountName:'
    ```

    You could also do it with JSONPath. First get the name of the pod using `kubectl get pods`. It will be different each time you run this lab. Then the command is e.g.

    ```
    kubectl get po web-dashboard-65b9cf6cbb-79vbs -o jsonpath='{.spec.serviceAccountName}'
    ```

    > `default`

    </details>

1.  <details>
    <summary>Inspect the Dashboard Application POD and identify the Service Account mounted on it.</summary>

    This is the same as the previous question.

    > `default`

    </details>

1.  <details>
    <summary>At what location is the ServiceAccount credentials available within the pod?</summary>

    Know that service account tokens are mounted in pods as a volume mount, so it is the `volumeMounts` section in which we look.

    ```
    kubectl describe pod
    ```

    Find the `Mounts` section which represents mounted volumes, and you will see a path to the mounted service account. From the anwsers, choose the one with the correct path prefix

    > `/var/run/secrets`

    </details>

1.  <details>
    <summary> Create a new ServiceAccount named <b>dashboard-sa</b>.</summary>

    Run the command `kubectl create serviceaccount dashboard-sa`

    </details>

1. Information only

1.  Now we are going to test the service account's access to the dashboard.

    1. Generate a token

        ```
        kubectl create token dashboard-sa
        ```

        This will generate a long string of characters.

    1. Select all the output using your mouse and copy it.
    1. Return to the dashboard UI, and paste this to the `Token` field
    1. Press Load Dashboard. It should now display the pod

1.  <details>
    <summary>Edit the deployment to change ServiceAccount from <b>default</b> to <b>dashboard-sa</b>.</summary>

    1. Use command `kubectl edit deployment web-dashboard`, which opens the running deployment in `vi`
    1. Move dowm to the deployment spec and insert the service account as shown:

      ```yaml
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        annotations:
          deployment.kubernetes.io/revision: "2"
        creationTimestamp: "2023-02-21T19:29:21Z"
        generation: 2
        name: web-dashboard
        namespace: default
        resourceVersion: "1499"
        uid: ac5a26bf-7a88-41cc-8db3-d5a4bd2ad31c
      spec:
        progressDeadlineSeconds: 600
        replicas: 1
        revisionHistoryLimit: 10
        selector:
          matchLabels:
            name: web-dashboard
        strategy:
          rollingUpdate:
            maxSurge: 25%
            maxUnavailable: 25%
          type: RollingUpdate
        template:
          metadata:
            creationTimestamp: null
            labels:
              name: web-dashboard
          spec:
            serviceAccountName: dashboard-sa    # <- Insert this line
            containers:
            - env:
              - name: PYTHONUNBUFFERED
                value: "1"
              image: gcr.io/kodekloud/customimage/my-kubernetes-dashboard
              imagePullPolicy: Always
              name: web-dashboard
              ports:
              - containerPort: 8080
                protocol: TCP
      ```

    1. Save and exit `vi`. The deployment will be updated

    </details>

1. Reload the dashboard and verify it works without pasting a token.