# Deploy the cluster

1. Now we can deploy the cluster

    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

    This will take around 5 minutes to complete. In the console, if you navigate to `Kubernetes Service` you can see it creating.

1. Connect to the cluster.

    When the terraform completes, you will see someting like the following. Copy the two `az` commands it is displaying and paste them to the terminal. Note that the subscription ID and resource group name will be different to what is displayed on this page.

    ```
    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    commands = <<EOT

    Now run the following commands to gain kubectl access to the cluster

    az account set --subscription a2b28c85-1948-4263-90ca-bade2bac4df4
    az aks get-credentials --resource-group kml_rg_main-4d5e3c08a48840da --name kodekloud-demo --overwrite-existing
    EOT
    ```

1. Check nodes

    ```bash
    kubectl get nodes
    ```

Once all nodes are showing ready, the cluster is ready to use!

Prev: [Install terraform](./03-install-terraform.md)