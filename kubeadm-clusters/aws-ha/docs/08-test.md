## Create a test service

Run the following on `student-node`

1.  Ensure all calico pods are running. They can take a while to initialise

    ```bash
    watch kubectl get pods -n calico-system
    ```

    Press `CTRL-C` to exit watch when pods are stable

1. All 5 nodes should now be ready:

    ```
    kubectl get nodes
    ```

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

    Both should return the nginx welcome message as HTML text.

Congratulations! You now have a working HA kubeadm cluster.

## Viewing service with a browser

1. Refer to the outputs of the terraform run and get the IP address for either `node01` or `node02`. If you did not note these down, you can find the IP addresses from the [EC2 console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:) by looking in the `Public IPv4 ...` column (scroll right if this column is not in view).
1. Form a URL using the IP address (it will be different for you) and the NodePort number output from step 1 above, e.g.

    ```
    http://54.167.161.210:32182
    ```
1. Paste URL to your browser

