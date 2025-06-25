# Boot the controlplane

[//]: # (host:controlplane)



On the `controlplane` node

1.  Set shell variables for the pod and network network CIDRs. The API server advertise address is using the predefined variable described in the [previous section](./04-node-setup.md). Note that with bridged mode virtual machines (the default for this installation) it is important that neither of the following IP ranges overlap your home network which for nearly all broadband router default configurations is `192.168.0.0/24`

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

1.  Install Calico CNI for cluster networking

    Calico is a CNI that supports Network Policies. An alternative CNI that's discussed in the course is Flannel, however Flannel does not support Netowrk Policy. It provides only the basic pod networking.

    1. Install the Tigera operator and custom resource definitions.

        ```bash
        kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.1/manifests/tigera-operator.yaml
        ```

    1. Install Calico by creating the necessary custom resources. If using bridge networking for your virtual machines which is the default, we are going to have to make a modification to these custom resources to agree with the POD_CIDR we set above, or else the pod network will overlap your home network and the cluster won't work.

        1. Download the custom resource manifest

            ```bash
            curl -LO https://raw.githubusercontent.com/projectcalico/calico/v3.30.1/manifests/custom-resources.yaml
            ```

        1. Use `sed` to change the ipPool network in the manifest from the default of `192.168.0.0/16` to the value of `POD_IP` set above. You could do it by editing with `vi` but `sed` is faster.

            ```bash
            sed -i "s#192.168.0.0/16#$POD_CIDR#" custom-resources.yaml
            ```

        1. Apply the edited manifest

            ```bash
            kubectl apply -f custom-resources.yaml
            ```

    It will take a minute or two for all the calico resources to be up and running. You can monitor the progress with the following command

    ```
    watch kubectl get tigerastatus
    ```

    Wait until all items in the list have a `True` status for available, then press `CTRL-C` to exit the `watch` command.

    [Calico Installation Documentation](https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart)

[//]: # (command:sleep 120)

1.  Verify controlplane

    ```bash
    kubectl get pods -n kube-system
    ```

[Kubernetes Documentation Link](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

Next: [Join Workers](./06-workers.md)</br>
Prev: [Node setup](./04-node-setup.md)

