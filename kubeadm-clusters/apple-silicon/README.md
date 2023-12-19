# Installing Kubernetes the kubeadm way on Apple Silicon

In here is the setup specific to Apple Silicon (M1/M2) Macs. VirtualBox currently does not have good support for these Macs, therefore we will create the Ubuntu virtual machines using Multipass.

## Prerequisites

* Apple M1 or M2 system
* 8GB RAM (16GB preferred).
    * All configurations - One control plane node will be provisioned - `kubemaster`
    * If you have less than 16GB then only one worker node will be provisioned - `kubeworker1`
    * If you have 16GB or more then two workers will be provisioned - `kubeworker01` and `kubeworker2`

You'll need to install the following first.

* Multipass - https://multipass.run/install. Follow the instructions to install it and check it is working properly. You should be able to successfully create a test Ubuntu VM following their instructions. Delete the test VM when you're done.
* JQ - https://github.com/stedolan/jq/wiki/Installation#macos

Additionally

* Your account on your Mac must have admin privilege and be able to use `sudo`
* Clone this repo down to your Mac. Open your Mac's terminal application. All commands in this guide are executed from the terminal.

    ```bash
    mkdir ~/kodekloud
    cd ~/kodekloud
    git clone https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git
    cd certified-kubernetes-administrator-course/kubeadm-clusters/apple-silicon
    ```

## Install Cluster

These instructions follow the steps in the lecture videos fairly closely, however we need to use versions of the various software to install that are compatible with ARM architecture. This means that whereever the lecture shows sofware downloads with `linux-amd64` in the name, we are going to choose the corresponding `linux-arm64` version.

### Step 1 - Provision VMs with Multipass

Because we cannot use VirtualBox and are instead using Multipass, [a script is provided](./deploy-virtual-machines.sh) to create the three VMs.

1. Run the VM deploy script from your Mac terminal

    ```bash
    ./deploy-virtual-machines.sh
    ```

2. Verify you can connect to all three (two if your Mac only has 8GB RAM) VMs:

    ```bash
    multipass shell kubemaster
    ```

    You should see a command prompt like `ubuntu@kubemaster:~$`

    Type the following to return to the Mac terminal

    ```bash
    exit
    ```

    Do this for `kubeworker01` and `kubeworker02` as well

    In the following instructions when it says "connect to" any of the VMs, it means use the `multipass shell` command as above.


### Step 2 - Set up Operating System Prerequisites

Connect to each VM in turn, and run the following:

1. Execute the following commands in each VM terminal

    ```bash
    # Load required kernel modules
    sudo modprobe overlay
    sudo modprobe br_netfilter

    # Persist modules between restarts
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF

    # Set required networking parameters
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
    EOF

    # Apply sysctl params without reboot
    sudo sysctl --system
    ```

### Step 3 - Set up Container Runtime (containerd)

Here we deviate slightly from the lecture. Using the default version of `containerd` that is provided by `apt-get install` results in a cluster with crashlooping pods, so we install a version that works by downloading directly from their github site.

Connect to each VM in turn, and run the following scripts:

1. Download and unzip the containerd application

    ```bash
    curl -LO https://github.com/containerd/containerd/releases/download/v1.7.0/containerd-1.7.0-linux-arm64.tar.gz
    sudo tar Czxvf /usr/local containerd-1.7.0-linux-arm64.tar.gz
    ```

1. Download and place the systemd unit file

    ```bash
    curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
    sudo mkdir -p /usr/lib/systemd/system
    sudo mv containerd.service /usr/lib/systemd/system/
    ```

1. Create containerd configuration file

    ```bash
    sudo mkdir -p /etc/containerd/
    sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
    ```

1. Enable systemd CGroup driver

    ```bash
    sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
    ```

1. Set containerd to auto-start at boot (enable it).

    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable --now containerd
    ```


### Step 4 - Install kubeadm, kubelet and kubectl

Connect to each VM in turn and perform the following steps

1. Update the apt package index and install packages needed to use the Kubernetes apt repository

    ```bash
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    ```

1.  Download the Google Cloud public signing key

    ```bash
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    ```

1.  Add the Kubernetes apt repository

    ```bash
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    ```

1.  Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:

    ```bash
    KUBE_VERSION=1.26.4
    sudo apt-get update
    sudo apt-get install -y kubelet=${KUBE_VERSION}-00 jq kubectl=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 runc kubernetes-cni=1.2.0-00
    sudo apt-mark hold kubelet kubeadm kubectl
    ```

1. Configure crictl to work with containerd

    ```bash
    sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
    ```

### Step 5 - Provisioning the Kubernetes Cluster

1. Configure the Control Plane

    1. Connect to the control plane node
    1. Determine the IP address of the control plane node. We will need it for the forthcoming `kubeadm init` command.

        ```bash
        dig +short kubemaster | grep -v 127
        ```

    1. Initialize control plane.

        As per the lecture, we are going to use a pod CIDR of 10.244.0.0/16. Run the following command, replacing `[IP]` with the IP address you got from the previous step

        ```bash
        sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=[ip]
        ```

    1. Set up the kubeconfig file.

        ```bash
        mkdir ~/.kube
        sudo cp /etc/kubernetes/admin.conf ~/.kube/config
        sudo chown ubuntu:ubuntu ~/.kube/config
        chmod 600 ~/.kube/config
        ```

    1. Verify the cluster is contactable

        ```bash
        kubectl get pods -n kube-system
        ```

        You should see some output. Pods may not all be ready yet.

    1. Install Weave for cluster networking

        ```bash
        kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"
        ```

        It will take up to a minute for the weave pod to be ready

    1. Prepare the join command for the worker nodes

        ```bash
        kubeadm token create --print-join-command
        ```

        Copy the output of this. We will need to paste it on the worker(s)

1. Configure the worker nodes

    For each worker node

    1. Connect to the worker node
    1. Paste the join command you copied from the final step of configuring the control plane to the command prompt and run it. Put `sudo` on the command line first, then passte the join command after sudo so it looks like

        ```
        sudo kubeadm join 192.168.64.4:6443 --token whd8v4.EXAMPLE --discovery-token-ca-cert-hash sha256:9537c57af216775e26ffa7ad3e495-5EXAMPLE`
        ```


## Notes

1. Deleting the VMs

    ```
    ./delete-virtual-machines.sh
    ```

1. Stopping and restarting the VMs

    To stop the VMs, stop the workers first, then finally kubemaster

    ```bash
    multipass stop kubeworker01
    multipass stop kubeworker02
    multipass stop kubemaster
    ```

    To restart them, start the control plane first

    ```bash
    multipass start kubemaster
    # Wait 30 sec or so
    multipass start kubeworker01
    multipass start kubeworker02
    ```

1. To see the state of VMs, run

    ```bash
    multipass list
    ```

1.  Multipass allocates IP addresses from the Mac's DHCP server to assign to VMs. When the VMs are deleted, it does not release them. If you build and tear down this a few times, you will run out of addresses on the network used for this purpose. Reclaiming them is a manaul operation. To do this, you must remove the spent addresses from the file `/var/db/dhcpd_leases` This file looks like this:

    ```json
    {
            name=kubemaster
            ip_address=192.168.64.22
            hw_address=1,52:54:0:eb:c4:7
            identifier=1,52:54:0:eb:c4:7
            lease=0x643f6f22
    }
    {
            name=kubeworker01
            ip_address=192.168.64.23
            hw_address=1,52:54:0:93:3d:91
            identifier=1,52:54:0:93:3d:91
            lease=0x643f6f20
    }
    ```

    Once you have deleted all your VMs, edit this file and remove all the blocks (including their surrounding `{ }`) related to kubemaster and kubeworker. In the above example you would delete everything you can see. Do this for all kubemsters and kubeworkers.

    ```
    sudo vi /var/db/dhcpd_leases
    ```