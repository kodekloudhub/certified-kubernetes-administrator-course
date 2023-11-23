# Boot the worker nodes

Here we will join the worker nodes to the cluster. You will need the `kubeadm join` command from the previous step

Ref: https://stackoverflow.com/questions/59629319/unable-to-upgrade-connection-pod-does-not-exist

## Join Workers

[//]: # (host:kubenode01-kubenode02)
[//]: # (comment:Run kubeadm join)

On each of `kubenode01` and `kubenode02` do the following

1.  Become root (if you are not already)

    ```
    sudo -i
    ```

1.  Join the node

    > Paste the `kubeadm join` command output by `kubeadm init` on the control plane

### Verify

On `kubemaster` run the following. After a few seconds both nodes should be ready

```
kubectl get nodes
```

Prev: [Boot controlplane](./05-controlplane.md)</br>
Next: [Test](./07-test.md)

