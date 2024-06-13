# Amazon EKS Cluster

In this guide, we will deploy an EKS cluster in the KodeKloud AWS Playground using Terraform. This cluster utilises an *unmanaged* node group, i.e. one we have to deploy and join manually as the playground does not support the creation of managed node groups.

If you want to do this manually from the AWS console, you can follow the guide created by Raymond Bao Ly [here](https://kodekloud.com/community/t/playground-series-how-to-create-an-eks-cluster-in-kodekloud-playground/330748).

This terraform code will create an EKS cluster called `demo-eks` and will have the same properties as the manually deployed version linked above.

## Start an AWS Playground

[Click here](https://kodekloud.com/topic/playground-aws/) to start a playground, and click `START LAB` to request a new AWS Cloud Playground instance. After a few seconds, you will receive your credential to access AWS Cloud console.

Note that you must have KodeKloud Pro subscription to run an AWS playground. If you have your own AWS account, this should still work, however you will bear the cost for any resources created until you delete them.

We will run this entire lab in AWS CloudShell which is a Linux terminal you run inside the AWS console and has most of what we need preconfigured. [Click here](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1) to open CloudShell.

From here on, all commands must be run in the CloudShell terminal

## Install Terraform

```bash
curl -O https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
mkdir -p ~/bin
mv terraform ~/bin/
terraform version
```

## Clone this repo

```bash
git clone https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git
```

Now change into the EKS directory

```bash
cd certified-kubernetes-administrator-course/managed-clusters/eks
```

## Provision the infrastructure

```bash
terraform init
terraform plan
terraform apply
```

This may take up to 10 minutes to complete. When it completes, you will see something similar to this at the end of all the output. You will need the value of `NodeInstanceRole` later.

```
Outputs:

NodeAutoScalingGroup = "demo-eks-stack-NodeGroup-UUJRINMIFPLO"
NodeInstanceRole = "arn:aws:iam::387779321901:role/demo-eks-node"
NodeSecurityGroup = "sg-003010e8d8f9f32bd"
```

## Set up access and join nodes

Do the following at the CloudShell command line

1.  Create a KUBECONFIG for `kubectl`

    ```bash
    aws eks update-kubeconfig --region us-east-1 --name demo-eks
    ```

1.  Join the worker nodes

    1. Download the node authentication ConfigMap

        ```
        curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/aws-auth-cm.yaml
        ```

    1.  Edit the ConfigMap YAML to add in the `NodeInstanceRole` we got from terraform

        ```bash
        vi aws-auth-cm.yaml
        ```

        Delete the text `<ARN of instance role (not instance profile)>` and replace it with the value for `NodeInstanceRole` we got from terraform, then save and exit.

        ```yaml
        apiVersion: v1
        kind: ConfigMap
        metadata:
        name: aws-auth
        namespace: kube-system
        data:
        mapRoles: |
            - rolearn: <ARN of instance role (not instance profile)> # <- EDIT THIS
            username: system:node:{{EC2PrivateDNSName}}
            groups:
                - system:bootstrappers
                - system:nodes

        ```

    1.  Apply the edited ConfigMap to join the nodes

        ```bash
        kubectl apply -f aws-auth-cm.yaml
        ```

        Wait 2-3 minutes for node join to complete, then

        ```bash
        kubectl get node -o wide
        ```

        You should see 3 worker nodes in ready state. Note that with EKS you do not see control plane nodes, as they are managed by AWS.

1.  View the completed cluster in the [EKS Console](https://us-east-1.console.aws.amazon.com/eks/home?region=us-east-1).