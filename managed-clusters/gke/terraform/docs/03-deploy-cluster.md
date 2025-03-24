# Deploy the cluster

1. Export the project ID to terraform. The project ID is provided as an environment variable by Cloudshell. We need to set the appropriate terraform environment variable from it:

    ```bash
     export TF_VAR_project_id=$GOOGLE_CLOUD_PROJECT
     ```

1. Now we can deploy the cluster

    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

    This will take at least 5 minutes to complete. In the console, if you navigate to `Kubernetes Engine` you can see it creating.

1. Connect to the cluster.

    Run the following command in the Cloudshell to authenticate kubectl to use the cluster

    ```bash
    gcloud container clusters get-credentials kodekloud-demo-cluster --region us-west1 --project $GOOGLE_CLOUD_PROJECT
    ```

1. Check nodes

    ```bash
    kubectl get nodes
    ```

Once all nodes are showing ready, the cluster is ready to use!

Prev: [Install terraform](./02-install-terraform.md)