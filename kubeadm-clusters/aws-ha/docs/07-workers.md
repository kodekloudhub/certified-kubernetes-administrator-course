# Join the worker nodes

1.  SSH to `node01`
1.  Become root

    ```bash
    sudo -i
    ```

1. Paste the join command for *worker* nodes that was output by `kubeadm init` on `controlplane01`

1. Return to `student-node`

    ```
    exit
    exit
    ```

1. Repeat the steps 2, 3 and 4 on `node02`

1. Now you should be back on `student-node`. Check all nodes are up

    ```bash
    kubectl get nodes -o wide
    ```

    There should now be 3 control nodes and 2 workers.

Next: [Test](./08-test.md)</br>
Prev: [Control Plane Setup](./06-controlplane.md)

