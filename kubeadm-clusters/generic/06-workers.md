# Boot the worker nodes

Here we will join the worker nodes to the cluster. You will need the `kubeadm join` command from the previous step

Ref: https://stackoverflow.com/questions/59629319/unable-to-upgrade-connection-pod-does-not-exist

## Join Workers

If you did not note down the join command on the cotrolplane node after running `kubeadm`, you can recover it by running the following on `controlplane`

```bash
kubeadm token create --print-join-command
```

[//]: # (host:node01-node02)
[//]: # (comment:Run kubeadm join)

On each of `node01` and `node02` do the following

1.  Copy the `kubeadm join` command from `controlplane` and use `sudo` to apply it

    ```
    sudo <paste join command here>
    ```

    It will look like this (the IP address and random character values will be different for you)

    ```
    sudo kubeadm join 192.168.230.143:6443 --token u1cm5e.j2zafff9h25jslsf \
        --discovery-token-ca-cert-hash sha256:7b05dd5ed5d0cd7ef71f634a91344888458a145439aea96a01e45931823265f5
    ```

    then press ENTER to join the node

### Verify

On `controlplane` run the following. After a few seconds both nodes should be ready

```
kubectl get nodes
```

Next: [Test](./07-test.md)</br>
Prev: [Boot controlplane](./05-controlplane.md)

