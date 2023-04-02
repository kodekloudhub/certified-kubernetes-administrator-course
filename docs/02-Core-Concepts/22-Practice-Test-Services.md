# Practice Test - Services
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-services/)

#### Solutions to Practice test - Services

1. <details>
    <summary>How many Services exist on the system?</summary>

    ```
    kubectl get services
    ```

    Count the number of services (if any)
    </details>


1. Information only

1.  <details>
    <summary>What is the type of the default kubernetes service?</summary>

    From the output of Q1, examine the `TYPE` column.
    </details>

1.  <details>
    <summary>What is the targetPort configured on the kubernetes service?</summary>

    ```
    $ kubectl describe service | grep TargetPort
    ```
    </details>

1.  <details>
    <summary>How many labels are configured on the kubernetes service?</summary>

    ```
    kubectl describe service
    ```

    ...and look for labels.

    --- OR ---

    ```
    kubectl describe service --show-labels
    ```

    </details>

1.  <details>
    <summary>How many Endpoints are attached on the kubernetes service?</summary>

    ```
    kubectl describe service
    ```

    ...and look for endpoints

    </details>

1.  <details>
    <summary>How many Deployments exist on the system now?</summary>

    ```
    kubectl get deployment
    ```

    Count the deployments (if any)
    </details>

1.  <details>
    <summary>What is the image used to create the pods in the deployment?</summary>

    ```
    kubectl describe deployment
    ```

    Look in the containers section.

    --- OR ---

    ```
    kubectl get deployment -o wide
    ```

    Look in the `IMAGES` column

    </details>

1.  <details>
    <summary>Are you able to access the Web App UI?</summary>

    Try to access the Web Application UI using the tab simple-webapp-ui above the terminal.

    </details>

1.  <details>
    <summary>Create a new service to access the web application using the service-definition-1.yaml file.</summary>

    ```
    vi service-definition-1.yaml
    ```

    Fill in the values as directed, save and exit.

    ```
    kubectl create -f service-definition-1.yaml
    ```
    </details>

1. Test newly deployed service.

