# Networking

1. Select VPC - there should only be one choice, the Default VPC.

1. Select values for the Subnets fields. When you click on `Select subnets`, a drop list will appear. All subnets will be selected.

    For the availability zone `us-east-1e`, users cannot make changes or use it. So in our EKS Cluster creation, we will not select the subnet from the `us-east-1e` availability zone.

    You must select at least two subnets for a cluster to be valid. In this tutorial we will use subnets from `us-east-1a`, `us-east-1b`, `us-east-1c` availability zones, so deselect the others.

    ![](../images/04-subnets.png)

1. Scroll to end and press `Next`.
1. At the following page (Observability), press `Next` again as there is nothing to do here.
1. At the following page (Select add-ons), press `Next` again as there is nothing to do here either.
1. At the following page (Configure selected add-ons settings), press `Next` again as there is nothing to do here either.

Prev: [Configure Cluster](./03-configure-cluster.md)<br/>
Next: [Create Cluster](./05-create-cluster.md)





