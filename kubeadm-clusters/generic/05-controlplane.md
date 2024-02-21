# Boot the controlplane on kubemaster

[//]: # (host:kubemaster)



On the `kubemster` node

1.  Set shell variables for the pod and network network CIDRs. The API server advertise address is using the predefined variable described in the [first section](./01-prerequisites.md)

    ```bash
    POD_CIDR=10.244.0.0/16
    SERVICE_CIDR=10.96.0.0/16
    ```

1.  Start controlplane

    Here we are using arguments to `kubeadm` to ensure that it uses the networks and IP address we want rather than choosing defaults which may be incorrect.

    ```bash
    sudo kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $INTERNAL_IP
    ```

[//]: # (command:sleep 10)

1.  Copy the `kubeadm join` command printed to your notepad to use on the worker nodes.

1.  Set up the kubeconfig so it can be used by the `vagrant` user


    1.  Create directory for kubeconfig, copy the admin kubeconfig as the default kubeconfig for `vagrant` user and set the correct file permissions

        ```bash
        mkdir ~/.kube
        sudo cp /etc/kubernetes/admin.conf ~/.kube/config
        sudo chown $(id -u):$(id -g) ~/.kube/config
        ```

    1.  Verify

        ```bash
        kubectl get pods -n kube-system
        ```

1.  Install Weave networking

    ```bash
    kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
    ```


[//]: # (command:kubectl rollout status daemonset weave-net -n kube-system --timeout=90s)

1.  Verify controlplane

    ```bash
    kubectl get pods -n kube-system
    ```

Prev: [Node setup](./04-node-setup.md)</br>
Next: [Join Workers](./06-workers.md)

