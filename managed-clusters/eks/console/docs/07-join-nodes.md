# Join Worker Nodes

Now that CloudFormation has created the EC2 instances for the worker nodes, we need to join them to the cluster.

1. Return to the CloudShell terminal. If you closed it, press the button at the top to reopen it. If it tells you the session is closed due to inactivity, hit Enter to restart it.
1. Download the node configmap

    ```
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/aws-auth-cm.yaml
    ```
1. Now edit it in `vi`

    ```
    vi aws-auth-cm.yaml
    ```

    Where it says `rolearn: <ARN of instance role (not instance profile)>`, you need to delete `<ARN of instance role (not instance profile)>` and paste in the value for `NodeInstanceRole` you got from the previous section. When you are done, it should look something like this (though the actual value will be different for you).

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: aws-auth
      namespace: kube-system
    data:
      mapRoles: |
        - rolearn: arn:aws:iam::851725221429:role/eks-cluster-stack-NodeInstanceRole-8OYkncRSa4gA
          username: system:node:{{EC2PrivateDNSName}}
          groups:
            - system:bootstrappers
            - system:nodes
    ```

1. Save and exit from vi, then apply the configmap

    ```
    kubectl apply -f aws-auth-cm.yaml
    ```

    It will take a minute or so for all nodes to join the cluster

    ```
    kubectl get nodes
    ```

Congratulations! Your cluster is now up and you can create resources.

Prev: [Add Cluster Nodes](./06-nodes.md)<br/>
Next: [Accessing Node Port services](./08-node-port.md)

