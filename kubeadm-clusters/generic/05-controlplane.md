# Boot the controlplane

[//]: # (host:controlplane)



On the `controlplane` node

1.  Set shell variables for the pod and network network CIDRs. The API server advertise address is using the predefined variable described in the [previous section](./04-node-setup.md)

    ```bash
    POD_CIDR=10.244.0.0/16
    SERVICE_CIDR=10.96.0.0/16
    ```

1.  Start controlplane

    Here we are using arguments to `kubeadm` to ensure that it uses the networks and IP address we want rather than choosing defaults which may be incorrect.

    ```bash
    sudo kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $PRIMARY_IP
    ```

[//]: # (command:sleep 10)

1.  Copy the `kubeadm join` command printed to your notepad to use on the worker nodes.

1.  Set up the kubeconfig so it can be used by the user you are logged in as

    1.  Create directory for kubeconfig, copy the admin kubeconfig as the default kubeconfig for current user (`vagrant` on VirtualBox, `ubuntu` on Multipass and AWS) and set the correct file permissions.</br>Note that in Linux, the command `id -u` returns your user name on the system and `id -g` returns your group name.

        ```bash
        {
            mkdir ~/.kube
            sudo cp /etc/kubernetes/admin.conf ~/.kube/config
            sudo chown $(id -u):$(id -g) ~/.kube/config
            chmod 600 ~/.kube/config
        }
        ```

    1.  Verify

        ```bash
        kubectl get pods -n kube-system
        ```

1.  Install Weave networking

    Some of you may have noticed the announcement that WeaveWorks is no longer trading. At this time, this does not mean that Weave is not a valid CNI. WeaveWorks software has always been and remains to be open source, and as such is still useable. It just means that the company is no longer providing updates. While it continues to be compatible with Kubernetes, we will continue to use it as the other options (e.g. Calico, Cilium) require far more configuration steps.

    ```bash
    kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
    ```


[//]: # (command:kubectl rollout status daemonset weave-net -n kube-system --timeout=90s)

1.  Verify controlplane

    It may take around 30 seconds for Weave to become stable.

    ```bash
    kubectl get pods -n kube-system
    ```

Next: [Join Workers](./06-workers.md)</br>
Prev: [Node setup](./04-node-setup.md)

