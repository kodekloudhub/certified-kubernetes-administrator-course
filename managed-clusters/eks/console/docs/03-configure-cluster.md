# Configure Cluster

Now we will configure the cluster options

1. Navigate to the EKS console
    1. Click in the search box and type `eks`
    1. Click on `Elastic Kubernetes Service` in the result list

    ![](../images/03-eks.png)

1. Click on orange `Create cluster` button. This will open a list, and from that, choose `Create

    ![](../images/03-add-cluster.png)

1. In the Configure Cluster page:
    1. Select `Custom Configuration`
    1. Ensure `EKS Auto Mode` is switched OFF
      ![](../images/03-configure.png)
    1. Enter the name as `demo-eks` and select the cluster service role created above.
      ![](../images/03-configure-2.png)
    1. Enable ConfigMap for authentication (it's needed to join nodes later)
      ![](../images/03-configure-3.png)
    1. Then scroll to the end and press `Next` button.

Prev: [Create Service Role](./02-create-service-role.md)<br/>
Next: [Networking](./04-networking.md)

