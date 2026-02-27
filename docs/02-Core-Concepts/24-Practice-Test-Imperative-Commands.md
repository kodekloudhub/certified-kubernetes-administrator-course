# Practice Test - Imperative Commands
  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-imperative-commands-2/)

Solutions for Practice Test - Imperative Commands

1. Information

1.  <details>
    <summary>Deploy a pod named nginx-pod using the nginx:alpine image.</summary>

    ```
    kubectl run nginx-pod --image=nginx:alpine
    ```
    </details>

1.  <details>
    <summary>Deploy a redis pod using the redis:alpine image with the labels set to tier=db.</summary>

    ```
    kubectl run redis --image=redis:alpine -l tier=db
    ```
    </details>

1.  <details>
    <summary>Create a service redis-service to expose the redis application within the cluster on port 6379.</summary>

    ```
    kubectl expose pod redis --port=6379 --name redis-service
    ```
    </details>

1.  <details>
    <summary>Create a deployment named webapp using the image kodekloud/webapp-color with 3 replicas.</summary>

    ```
    kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3
    ```
    </details>

1.  <details>
    <summary>Create a new pod called custom-nginx using the nginx image and expose it on container port 8080.</summary>

    ```
    kubectl run custom-nginx --image=nginx --port=8080
    ```
    </details>

1.  <details>
    <summary>Create a new namespace called dev-ns.</summary>

    ```
    kubectl create ns dev-ns
    ```
    </details>

1.  <details>
    <summary>Create a new deployment called redis-deploy in the dev-ns namespace with the redis image. It should have 2 replicas.</summary>

    ```
    kubectl create deployment redis-deploy -n dev-ns --image redis --replicas 2
    ```
    </details>

1.  <details>
    <summary>Create a pod called httpd using the image httpd:alpine in the default namespace.</br>Next, create a service of type ClusterIP by the same name (httpd).</br>The target port for the service should be 80.</summary>

    ```
    kubectl run httpd --image httpd:alpine --expose --port 80
    ```
    </details>

1.  <details>
    <summary>Which command would you use to display a list of all available API resources in your cluster?</summary>

    ```
    kubectl api-resources
    ```
    </details>

1.  <details>
    <summary>What is the SHORTNAME for horizontalpodautoscalers?</summary>

    ```
    hpa
    ```
    </details>

1.  <details>
    <summary>Which of the following resources is NOT namespaced (i.e., cluster-scoped)?</summary>

    ```
    nodes
    ```
    </details>

1.  <details>
    <summary>Which command would you use to get a description and details of the Pod resource?</summary>

    ```
    kubectl explain pod
    ```
    </details>

1.  <details>
    <summary>When writing a YAML manifest for a Pod, you want to understand what fields are available under containers. Which command would you use to explore the structure of the containers field?</summary>

    ```
    kubectl explain pod.spec.containers
    ```
    </details>

1.  <details>
    <summary>You can drill down into nested fields using dot notation. Use kubectl explain to explore the spec field of a Pod. What is the TYPE of the containers field?</summary>

    ```
    []Object
    ```
    </details>

1.  <details>
    <summary>Let's explore the Deployment resource. What is the TYPE of the replicas field?</summary>

    ```
    integer
    ```
    </details>

1.  <details>
    <summary>What does the --recursive flag do when used with kubectl explain?</summary>

    ```
    Shows all nested fields recursively in a single output
    ```
    </details>

1.  <details>
    <summary>Use kubectl explain with the --recursive flag to explore the service.spec.ports structure. Looking at the recursive output, which of these fields is not available under service.spec.ports?</summary>

    ```
    hostNetwork
    ```
    </details>
