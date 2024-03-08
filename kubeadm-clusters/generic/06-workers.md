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

1.  Become root (if you are not already)

    ```
    sudo -i
    ```

1.  Join the node

    > Paste the `kubeadm join` command output by `kubeadm init` on the control plane

### Verify

On `controlplane` run the following. After a few seconds both nodes should be ready

```
kubectl get nodes
```

Next: [Test](./07-test.md)</br>
Prev: [Boot controlplane](./05-controlplane.md)

