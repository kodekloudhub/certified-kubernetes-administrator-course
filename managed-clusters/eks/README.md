# Amazon EKS Cluster

In this guide, we will deploy an EKS cluster in the KodeKloud AWS Playground using Terraform. This cluster utilises an *unmanged* node group, i.e. one we have to deploy and join manually as the playground does not support the creation of managed node groups.

If you want to do this manually from the AWS console, you can follow the guide created by Raymond Bao Ly [here](https://kodekloud.com/community/t/playground-series-how-to-create-an-eks-cluster-in-kodekloud-playground/330748)

The terraform code will create an EKS cluster called `demo-eks`

We will run this entire lab in AWS CloudShell with is a Linux terminal you run inside the AWS console with most of what we need preconfigured. [Click here](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1) to open CloudShell.

## Install Terraform

This deployment was tested using Terraform v1.5.3

If you don't already have Terraform installed, it is quite easy to do. Don't be alarmed if you don't know Terraform, just go with the flow here. Note that for a successful career in DevOps you cannot avoid Terraform, so we recommend our courses which can be found [on this page](https://kodekloud.com/learning-path-infrastructure-as-code/).

If you are studying or have studied Terraform, have a good look at the configuration files and see if you can understand how they work.


1. Go to https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
1. Select your operating system
    1. For macOS, the easiest way is to use homebrew as indicated.
    1. For Windows, select `AMD64` and download the zip file. The zip file contains only `terraform.exe`. Unzip it and place it somewhere you can run it from.
        * If you have the [chocolately](https://chocolatey.org/) package manager, simply run `choco install -y terraform` As Administrator.
        * If you don't, you really should consider [installing it](https://chocolatey.org/install).

## Create IAM access keys

We need access keys for Terraform to connect to the AWS account.

1. Log into AWS using the URL and credentials provided when you started the playground.
1. Go to the IAM console.
1. Select `Users` from the menu in the left panel.
1. Find your user account (for playground, username will begin with `odl_user_`), and click it.
1. Select `Security credentials` tab, scroll down to `Access keys` and press `Create access key`.
1. Select `Command Line Interface (CLI)` radio button.
1. Check the `Confirmation` checkbox at the bottom and press `Next`.
1. Enter anything for the description and press `Next`.
1. Show the secret access key. Copy access key and secret access key to a notepad for use later, or download the CSV file.

## Prepare the terraform code

You can either individually download all the `tf` files from this repo folder and open a command prompt/terminal in the folder you downloaded to, or clone the repo as follows:

```bash
git clone https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git
cd certified-kubernetes-administrator-course/managed-clusters/eks
```

Now create a file `terraform.tfvars` in the same folder as the rest of the `.tf` files. Use the following template for this file and replace the values for `access_key` and `secret_key` with the keys you generated in the step above

```
access_key   = "AKIASFFZ4IEWZEXAMPLE"
secret_key   = "st1i+TlfYn4+lpp4vYRNuxbafYm8jraCEXAMPLE"
```

## Provision the infrastructure

```bash
terraform init
terraform plan
terraform apply
```

This may take up to 10 minutes to complete.

## Set up access and join nodes

To use our cluster, we will use AWS CloudShell which gives us a terminal inside the AWS Console that has most of the tools we need pre-configured. Open CloudShell by [clicking here](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1)

Do the following at the CloudShell command line

1.  Create a KUBECONFIG for `kubectl`

    ```bash
    aws eks update-kubeconfig --region us-east-1 --name demo-eks
    ```