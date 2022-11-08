# Practice Test - Practice Test Service Accounts
  - Take me to [Practice Test](https://uklabs.kodekloud.com/topic/practice-test-service-accounts-2/)

Solutions to the Practice Test Service Accounts
- Run the command `kubectl get serviceaccounts` and count the number of accounts.

- Run the command `kubectl describe serviceaccount default` and look at the Tokens field.

- Run the command `kubectl describe serviceaccount` default and look at the Tokens field.

    <details>
    ```
    none
    ```
    </details>

- Run the command `kubectl describe deployment`

    <details>
    ```
    gcr.io/kodekloud/customimage/my-kubernetes-dashboard
    ```
    </details>

- Open the web-dashboard link located above the terminal and inspect the status.

    <details>
    ```
    Failed
    ```
    </details>

- As evident from the error in the web-dashboard UI, the pod makes use of a service account to query the Kubernetes API.

    <details>
    ```
    Service Account
    ```
    </details>

- The name of the Service Account is displayed in the error message on the dashboard. The deployment makes use of the ```default``` service account which we inspected earlier.

- Run the command ```kubectl get po -o yaml | grep -i serviceaccount``` and inspect serviceAccount.

    <details>
    ```
    default
    ```
    </details>

- Run the command ```kubectl describe pod``` and look for volume mount path.

    <details>
    ```
    /var/run/secrets
    ```
    </details>

- Run the command `kubectl create serviceaccount dashboard-sa`

- Use the ```kubectl edit deploy web-dashboard``` command and specify the serviceAccountName field inside the pod spec.

      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: web-dashboard
        namespace: default
      spec:
        replicas: 1
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
            serviceAccountName: dashboard-sa
            containers:
            - image: gcr.io/kodekloud/customimage/my-kubernetes-dashboard
              imagePullPolicy: Always
              name: web-dashboard
              ports:
              - containerPort: 8080
                protocol: TCP
