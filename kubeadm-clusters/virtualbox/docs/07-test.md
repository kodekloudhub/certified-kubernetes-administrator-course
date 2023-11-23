# Test the cluster

Here we will test the cluster by creating a workload with a node port service and get the results using `curl`

Do the following on `kubemaster`

[//]: # (host:kubemaster)

1. Deploy and expose an nginx pod

    ```bash
    kubectl create deployment nginx --image nginx:alpine
    kubectl expose deploy nginx --type=NodePort --port 80
    ```

[//]: # (command:kubectl wait deployment -n default nginx --for condition=Available=True --timeout=90s)

1.  Hit the new service

    ```bash
    PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
    curl http://kubenode01:$PORT_NUMBER
    curl http://kubenode02:$PORT_NUMBER
    ```

    Both should return the nginx welcome message as HTML text.

Note that this cluster is not exposed externally so you can't use your browser. This tutorial is only about proving you can set up a working kubeadm cluster. If you want a cluster to experiment with that you can use a browser on, consider [minikube](https://minikube.sigs.k8s.io/docs/start/)

Prev: [Worker nodes](./06-workers.md)

