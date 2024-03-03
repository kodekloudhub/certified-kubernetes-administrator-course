# Boot up controlplane

To create a highly available control plane, we install kubeadm on the first control plane node almost the same way as for a single control plane cluster, then we *join* the other control plane nodes in a similar manner to joining worker nodes

## controlplane01

1.  ssh to `controlplane01`

    ```bash
    ssh controlplane01
    ```

1. Become root
    ```bash
    sudo -i
    ```

1.  Set shell variable for the pod network CIDR.

    ```bash
    POD_CIDR=192.168.0.0/16
    ```

1. Boot the first control plane using the IP address of the load balancer as the control plane endpoint

    Set a shell variable to the IP of the loadbalancer

    ```bash
    LOADBALANCER=$(dig +short loadbalancer)
    ```

    ...and install Kubernetes using `--control-plane-endpoint` and `--upload-certs` which instructs it that we are building for multiple controlplane nodes.

    ```bash
    kubeadm init --pod-network-cidr $POD_CIDR \
        --control-plane-endpoint ${LOADBALANCER}:6443 \
        --upload-certs
    ```

    Copy both join commands that are printed to a notepad for use on other control nodes and the worker nodes.

1. Install network plugin (calico). Weave does not work too well with HA clusters.
    ```bash
    kubectl --kubeconfig /etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/tigera-operator.yaml
    kubectl --kubeconfig /etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/custom-resources.yaml
    ```

1.  Check we are up and running

    ```bash
    kubectl --kubeconfig /etc/kubernetes/admin.conf get pods -n kube-system
    ```

1.  Exit root shell

    ```bash
    exit
    ```

1.  Prepare the kubeconfig file for copying to `student-node` node, which is where we will run future `kubectl` commands from.

    ```bash
    {
      sudo cp /etc/kubernetes/admin.conf .
      sudo chmod 666 admin.conf
    }
    ```

1.  Exit to `student-node`

    ```bash
    exit
    ```

1. On `student-node`, Copy down the kubeconfig so we can run kubectl commands from `student-node`

    ```bash
    {
        mkdir ~/.kube
        scp controlplane01:~/admin.conf ~/.kube/config
    }

## controlplane02 and controlplane03

Be on `student-node`

For each of `controlplane02` and `controlplane03`

1.  SSH to `controlplane02`
1.  Become root

    ```bash
    sudo -i
    ```
1.  Paste the join command for *control* nodes that was output by `kubeadm init` on `controlplane01`
1.  Exit back to `student-node`
    ```bash
    exit
    exit
    ```
1. Repeat the steps 2,3 and 4 on `controlplane03`

Next: [Worker setup](./07-workers.md)</br>
Prev: [Node Setup](./05-node-setup.md)


