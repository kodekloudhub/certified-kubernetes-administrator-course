# Test the cluster

Here we will test the cluster by creating a workload with a node port service and get the results using `curl`

Do the following on `kubemaster`

1. Deploy and expose an nginx pod

    ```bash
    kubectl run nginx --image nginx:alpine --expose --port 80
    ```

1. Convert the service to NodePort

    ```bash
    kubectl edit service nginx
    ```

    Edit the `spec:` part of the service until it looks like this. Don't change anything above `spec:`

    ```yaml
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 80
        nodePort: 30080
      selector:
        run: nginx
      sessionAffinity: None
      type: NodePort
    ```

1.  Hit the new service

    ```
    curl http://kubenode01:30080
    curl http://kubenode02:30080
    ```

    Both should return the nginx welcome message as HTML text.

Note that this cluster is not exposed externally so you can't use your browser. This tutorial is only about proving you can set up a working kubeadm cluster. If you want a cluster to experiment with that you can use a browser on, consider [minikube](https://minikube.sigs.k8s.io/docs/start/)

Prev: [Worker nodes](./06-workers.md)

