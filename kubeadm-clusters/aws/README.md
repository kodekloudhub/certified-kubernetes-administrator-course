# Installing Kubernetes the kubeadm way on AWS EC2

Updated March 2024

This guide shows how to install a 3 node kubeadm cluster on AWS EC2 instances. If using the KodeKloud AWS Playground environment, please ensure you have selected region `us-east-1` (N. Virginia) from the region selection at the top right of the AWS console. To maintain compatibility with the playground permissions, we will use the following EC2 instance configuration.

* Instance type: `t3.medium`
* Operating System: Ubuntu 22.04 (at time of writing)
* Storage: `gp2`, 8GB

Note that this is an exercise in simply getting a cluster running and is a learning exercise only! It will not be suitable for serving workloads to the internet, nor will it be properly secured, otherwise this guide would be three times longer! It should not be used as a basis for building a production cluster.


[Get Started](./docs/01-prerequisites.md)

---

## Create a test service

Run the following on `student-node`

1. Deploy and expose an nginx pod

    ```bash
    kubectl run nginx --image nginx --expose --port 80
    ```

1. Convert the service to NodePort

    ```bash
    kubectl edit service nginx
    ```

    Edit the `spec:` part of the service until it looks like this. Don't change anything above `spec:`

    ```yaml
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 80
        nodePort: 30080
      selector:
        run: nginx
      sessionAffinity: None
      type: NodePort
    ```

1.  Get the _public_ IP of one of the worker nodes to use in the following steps. These were output by Terraform as `address_node01` and `address_node02`. You can also find this by looking at the [instances on the EC2 page](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) of the AWS console.

1.  Test with curl on `student-node`

    Replace the IP address with the one you chose from the above step

        ```bash
        curl http://44.201.135.110:30080
        ```

1.  Test from your own browser

    Replace the IP address with the one you chose from the above step

        ```
        http://44.201.135.110:30080
        ```

