# Test the cluster

Here we will test the cluster by creating a workload with a node port service and get the results using `curl`

Do the following on `controlplane`

[//]: # (host:controlplane)

1. Deploy and expose an nginx pod

    ```bash
    kubectl create deployment nginx --image nginx:alpine
    kubectl expose deploy nginx --type=NodePort --port 80

    PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
    echo -e "\n\nService exposed on NodePort $PORT_NUMBER"
    ```

[//]: # (command:kubectl wait deployment -n default nginx --for condition=Available=True --timeout=90s)

2.  Hit the new service

    ```bash
    curl http://node01:$PORT_NUMBER
    curl http://node02:$PORT_NUMBER
    ```

    If you get this error:
    ```
    curl: (7) Failed to connect to node01 port 30659 after 0 ms: Connection refused
    ```
    Wait a few seconds and try again. Both should return the nginx welcome message as HTML text.

Congratulations! You now have a working kubeadm cluster.

## Viewing service with a browser

### VirtualBox or Apple Silicon

If you installed the cluster with bridge networking (the default), then you can view NodePort services with your browser.

Run the following command on `controlplane` to get browser address, then copy the output to your browser:

```bash
echo "http://$(dig +short node01):$PORT_NUMBER"
```

### AWS

1. Refer to the outputs of the terraform run and get the IP address for either `node01` or `node02`. If you did not note these down, you can find the IP addresses from the [EC2 console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:) by looking in the `Public IPv4 ...` column (scroll right if this column is not in view).
1. Form a URL using the IP address (it will be different for you) and the NodePort number output from step 1 above, e.g.

    ```
    http://54.167.161.210:32182
    ```
1. Paste URL to your browser

You may also copy the KUBECONFIG to `student-node` thus allowing you to run `kubectl` commands from there:

1. Return to `student-node`.
1. Run the following:

    ```bash
    mkdir ~/.kube
    scp controlplane:~/.kube/config ~/.kube/config
    kubectl get pods -n kube-system
    ```


Prev: [Worker nodes](./06-workers.md)


