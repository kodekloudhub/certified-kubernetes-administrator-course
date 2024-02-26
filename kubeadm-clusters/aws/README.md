# Installing Kubernetes the kubeadm way on AWS EC2

Updated March 2024

This guide shows how to install a 3 node kubeadm cluster on AWS EC2 instances. If using the KodeKloud AWS Playground environment, please ensure you have selected region `us-east-1` (N. Virginia) from the region selection at the top right of the AWS console. To maintain compatibility with the playground permissions, we will use the following EC2 instance configuration.

* Instance type: `t3.medium`
* Operating System: Ubuntu 22.04 (at time of writing)
* Storage: `gp2`, 8GB

Note that this is an exercise in simply getting a cluster running and is a learning exercise only! It will not be suitable for serving workloads to the internet, nor will it be properly secured, otherwise this guide would be three times longer! It should not be used as a basis for building a production cluster.


[Get Started](./docs/01-prerequisites.md)

---

## Configure Operating System, Container Runtime and Kube Packages

First, be logged into `student-node` as directed above.

Repeat the following steps on `controlplane`, `node01` and `node02` by SSH-ing from `student-node` to each cluster node in turn, e.g.

```
ubuntu@student-node:~$ ssh controlplane
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.19.0-1028-aws x86_64)

Last login: Tue Jul 25 15:27:07 2023 from 172.31.93.38
ubuntu@controlplane:~$
```

Note that there's no step to disable swap, since EC2 instances are by default with swap disabled.


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
1.  Configure the container runtime to use systemd Cgroups. This part is the bit many students miss, and if not done results in a controlplane that comes up, then all the pods start crashlooping. `kubectl` will also fail with an error like `The connection to the server x.x.x.x:6443 was refused - did you specify the right host or port?`

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
1.  Get latest version of Kubernetes and store in a shell variable

    ```bash
    KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
    ```

1. Download the Kubernetes public signing key
    ```bash
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    ```

1. Add the Kubernetes apt repository
    ```bash
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list
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

1. Boot the control plane using the above configuration
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

1.  Prepare the kubeconfig file for copying to `student-node` node

    ```bash
    {
      sudo cp /etc/kubernetes/admin.conf .
      sudo chmod 666 admin.conf
    }
    ```

1.  Exit to `student-node`

    ```bash
    exit
    ```

1.  Copy kubeconfig down from `controlplane` to `student-node` and set proper permissions

    ```bash
    mkdir -p ~/.kube
    scp controlplane:~/admin.conf ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    chmod 600 ~/.kube/config
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

## Notes on the terraform code

Those of you who are also studying our Terraform courses should look at the terraform files and try to understand what is happening here.

One point of note is that for the `node` instances, we create network interfaces for them as separate resources, then attach these ENIs to the instances when they are built. The reason for this is so that the IP addresses of the instances can be known in advance, such that during instance creation `/etc/hosts` may be created by the user_data script.
