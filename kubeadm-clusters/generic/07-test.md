# Test the cluster

Here we will test the cluster by creating a workload with a node port service and get the results using `curl`

Do the following on `controlplane`

[//]: # (host:controlplane)

1. Deploy and expose an nginx pod

    ```bash
    kubectl create deployment nginx --image nginx:alpine
    kubectl expose deploy nginx --type=NodePort --port 80

    PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
    echo "Exposed on NodePort $PORT_NUMBER"
    ```

[//]: # (command:kubectl wait deployment -n default nginx --for condition=Available=True --timeout=90s)

1.  Hit the new service

    ```bash
    curl http://node01:$PORT_NUMBER
    curl http://node02:$PORT_NUMBER
    ```

    Both should return the nginx welcome message as HTML text.

Congratulations! You now have your own working kubeadm cluster.

## Viewing service with a browser

### VirtualBox or Apple Silicon

If you installed the cluster with bridge networking (the default), then you can view NodePort services with your browser.

Run the following command on `controlplane` to get browser address, then copy the output to your browser:

```bash
echo "http://$(dig +short node01):$PORT_NUMBER"
```

Prev: [Worker nodes](./06-workers.md)

