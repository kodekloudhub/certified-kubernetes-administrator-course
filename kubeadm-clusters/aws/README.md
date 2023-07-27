# Kubeadm on AWS EC2

This guide shows how to install a 3 node kubeadm cluster on AWS EC2 instances. If using the KodeKloud AWS Playground environment, please ensure you have selected region `us-east-1` (N. Virginia) from the region selection at the top right of the AWS console. To maintain compatibility with the playground permissions, we will use the following EC2 instance configuration.

* Instance type: `t3.medium`
* Operating System: Ubuntu 22.04 (at time of writing)
* Storage: `gp2`, 8GB

Note that this is an exercise in simply getting a cluster running and is a learning exercise only! It will not be suitable for serving workloads to the internet, nor will it be properly secured, otherwise this guide would be three times longer! It should not be used as a basis for building a production cluster.

# 1. Provision Infrastructure

We will provision the following infrastructure. The infrastructure will be created by Terraform, so as not to spend too much of the lab time just getting that provisioned, and to allow you to focus on the cluster installation.

![Infra](../../images/kubeadm-aws-architecture.png)


As can be seen in this diagram, we will create four EC2 instances; three form the cluster itself and the fourth, `student-node` is where you will coordinate the work from. This is similar to how the real exam works - you start on a student node, then use SSH to connect to cluster nodes. Note that SSH connections are only possible in the direction of the arrows. It is not possible to SSH from e.g. `controlplane` directly to `node01`. You must `exit` to `student-node` first. This is also how it is in the exam. The `student-node` assumes the role of a [bastion host](https://en.wikipedia.org/wiki/Bastion_host).

We have also set up direct connection from your workstation to the node ports of the workers so that you can browse any NodePort services you create (see security below).

Some basic security will be configured:

* Only you will be able to connect to the student-node. A piece of Terraform magic will determine your public IP address and set it in the security group of the student-node instance.
* Only you will be able to access the cluster's node ports over the Internet, using the same technique as above.
* Only the student node can SSH to the cluster nodes.
* Ports required by Kubernetes itself (inc. etcd) and Weave CNI will be configured in security groups on the cluster nodes.

Security issues that would make this unsuitable for a genuine production cluster:

* The kube nodes would be on private subnets (no direct access from the Internet) and placed behind a NAT gateway to allow them to download packages, or with a more extreme security posture, completely [airgapped](https://en.wikipedia.org/wiki/Air_gap_(networking)).
* Access to API server and etcd would be more tightly controlled.
* Use of default VPC is not recommended.
* A cloud load balancer coupled with an ingress controller would be provisioned to provide ingress to the cluster. It is _definitely_ not recommended to expose the worker nodes' node ports to the Internet as we are doing here!!!

Other things that will be configured by the Terraform code
* Host names set on the nodes: `student-node`, `controlplane`, `node01`, `node02`
* Content of `/etc/hosts` set up on all nodes for easy use of `ssh` command from student node.
* Generation of key pair for logging into instances via SSH.

Let's go ahead and get the infrastructure built!

Firstly, start an [AWS Playground](https://kodekloud.com/topic/playground-aws/), or if you have your own AWS account, you can use that but you'll bear the cost of the infrastructure while it is running.

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
cd certified-kubernetes-administrator-course/kubeadm-clusters/aws
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

If this all runs correctly, you will see something like the following at the end of all the output. IP addresses _will_ be different for you. Path to SSH key file (after `-i`) will be different on Windows and may be different on Mac.

```
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

connect_command = "ssh -i ~/kubeadm-aws.pem ubuntu@3.94.180.170"
node01 = "18.205.245.169"
node02 = "75.101.200.29"
```

Copy all these outputs to a notepad for later use.

1. Wait for all instances to be ready (Instance state - `running`, Status check - `2/2 checks passed`). This will take 2-3 minutes. You may have to hit the refresh button a couple of times. We should now have something that looks like this: ![instances](../../images/kubeadm-ec2-instances-ready.png)
1. Test you can log in.
    1. You can do it directly from your terminal by copying and pasting the value of `connect_command` that was output at the end of the terraform run, _or_
    1. Use MobaXterm or another SSH client to connect to the IP address output as part of the connect command, as user `ubuntu`, and you will also need to give it the path to the SSH key file, which is the path after `-i` in the `connect_command`.

## Prepare the student node

We will install kubectl here so that we can run commands against the cluster when it is built

1. Become root (saves typing `sudo` before every command)
    ```bash
    sudo -i
    ```
1. Update the apt package index and install packages needed to use the Kubernetes apt repository:
    ```bash
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl
    ```

1. Download the Google Cloud public signing key
    ```bash
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    ```

1. Add the Kubernetes apt repository
    ```bash
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    ```

1. Update apt package index, install kubectl, and pin its version
    ```bash
    apt-get update
    apt-get install -y kubectl
    apt-mark hold kubectl
    ```

1. Exit the root shell

    ```bash
    exit
    ```

## Configure Operating System, Container Runtime and Kube Packages

First, be logged into `student-node` as directed above.

Repeat the following steps on `controlplane`, `node01` and `node02` by SSH-ing from `student-node` to each cluster node in turn, e.g.

```
ubuntu@studentnode:~$ ssh controlplane
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.19.0-1028-aws x86_64)

Last login: Tue Jul 25 15:27:07 2023 from 172.31.93.38
ubuntu@controlplane:~$
```

1. Become root (saves typing `sudo` before every command)
    ```bash
    sudo -i
    ```
1. Update the apt package index and install packages needed to use the Kubernetes apt repository:
    ```bash
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl
    ```
1. Set up the required kernel modules and make them persistent
    ```bash
    cat <<EOF > /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF

    modprobe overlay
    modprobe br_netfilter
    ```
1.  Set the required kernel parameters and make them persistent
    ```bash
    cat <<EOF > /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
    EOF

    sysctl --system
    ```
1. Install the container runtime
    ```bash
    apt-get install -y containerd
    ```
1.  Configure the container runtime to use CGroups. This part is the bit many students miss, and if not done results in a controlplane that comes up, then all the pods start crashlooping.

    1. Create default configuration

        ```bash
        mkdir -p /etc/containerd
        containerd config default > /etc/containerd/config.toml
        ```
    1. Edit the configuration to set up CGroups

        ```
        vi /etc/containerd/config.toml
        ```

        Scroll down till you find a line with `SystemdCgroup = false`. Edit it to be `SystemdCgroup = true`, then save and exit vi

    1.  Restart containerd

        ```bash
        systemctl restart containerd
        ```

1. Download the Google Cloud public signing key
    ```bash
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    ```

1. Add the Kubernetes apt repository
    ```bash
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    ```

1. Update apt package index, install kubelet, kubeadm and kubectl, and pin their version
    ```bash
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl
    ```

1.  Configure `crictl` in case we need it to examine running containers
    ```bash
    crictl config \
        --set runtime-endpoint=unix:///run/containerd/containerd.sock \
        --set image-endpoint=unix:///run/containerd/containerd.sock
    ```

1. Exit root shell
    ```bash
    exit
    ```

1.  Return to `student-node`

    ```bash
    exit
    ```

    Repeat the above till you have done `controlplane`, `node01` and  `node02`

## Boot up controlplane

1.  ssh to `controlplane`

    ```bash
    ssh controlplane
    ```

1. Become root
    ```bash
    sudo -i
    ```

1. Boot the control plane
    ```bash
    kubeadm init
    ```

    Copy the join command that is printed to a notepad for use on the worker nodes.

1. Install network plugin (weave)
    ```bash
    kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
    ```

1.  Check we are up and running

    ```bash
    kubectl --kubeconfig /etc/kubernetes/admin.conf get pods -n kube-system
    ```

1.  Exit root shell

    ```bash
    exit
    ```

1.  Prepare the kubeconfig file for copying to `student-node`

    ```bash
    {
    sudo cp /etc/kubernetes/admin.conf .
    sudo chown ubuntu:ubuntu admin.conf
    }
    ```

1.  Exit to student node

    ```bash
    exit
    ```

1.  Copy kubeconfig down from `controlplane` to `student-node`

    ```
    mkdir ~/.kube
    scp controlplane:~/admin.conf ~/.kube/config
    ```

1.  Test it

    ```
    kubectl get pods -n kube-system
    ```

## Join the worker nodes

1.  SSH to `node01`
1.  Become root

    ```bash
    sudo -i
    ```

1. Paste the join command that was output by `kubeadm init` on `controlplane`

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

1.  Test with curl

    1. Get the _internal_ IP of one of the nodes

        ```bash
        kubectl get node node01 -o wide
        ```

        This will output the following (INTERNAL-IP will be different for you)

        ```
        NAME     STATUS   ROLES    AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
        node01   Ready    <none>   13m   v1.27.4   172.31.26.150   <none>        Ubuntu 22.04.2 LTS   5.19.0-1028-aws   containerd://1.6.12
        ```

    1. Using the INTERNAL-IP and the nodePort value set on the service, form a `curl` command. The IP will be different to what is shown here.

        ```bash
        curl http://172.31.26.150:30080
        ```

1.  Test from your own browser

    1. Get the _public_ IP of one of the nodes. These were output by Terraform. You can also find this by looking at the instances on the EC2 page of the AWS console.

    1. Using the public IP and the nodePort value set on the service, form a URL to paste into your browser. The IP will be different to what is shown here.

        ```
        http://18.205.245.169:30080/
        ```