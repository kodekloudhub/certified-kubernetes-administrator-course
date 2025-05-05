# Demo - Deployment with Kubeadm tool

- Take me to [Lecture](https://kodekloud.com/topic/demo-deployment-with-kubeadm/)

# Apple Silicon

If you have an Apple M1 or M2 (Apple Silicon) machine, then please follow the separate instructions [here](../../apple-silicon/README.md).

For all other operating systems/hardware including Intel Apple, please remain on this page...

# VirtualBox/Vagrant

In this lab, you will build your own 3-node Kubernetes cluster using `kubeadm` with `VirtualBox` and `Vagrant`

## Important Note

This lab cannot currently be performed on Apple M1/M2. We are waiting for VirtualBox to release a version that is fully compatible with Apple Silicon.

## Changes to Lecture

Since the video was recorded, Kubernetes and Ubuntu have progressed somewhat.

We are now using the latest stable release of Ubuntu - 22.04

Docker is no longer supported as a container driver. Instead we will install the `containerd` driver and associated tooling.

# Lab Instructions

1. Install required software

    <details>

    * VirtualBox: https://www.virtualbox.org/
    * Vagrant: https://developer.hashicorp.com/vagrant/downloads

    </details>

1. Clone this repository

    <details>

    ```
    git clone https://github.com/kodekloudhub/certified-kubernetes-administrator-course.git
    cd certified-kubernetes-administrator-course
    ```

    </details>

1. Bring up the virtual machines

    <details>

    ```
    vagrant up
    ```

    This will start 3 virtual machines named

    * `kubemaster` - where we will install the control plane
    * `kubenode01`
    * `kubenode02`

    </details>

1. Check you can SSH to each VM

    <details>

    Note: To exit from VM's ssh session, enter `exit`

    ```
    vagrant ssh kubemaster
    ```

    ```
    vagrant ssh kubenode01
    ```

    ```
    vagrant ssh kubenode02
    ```

    </details>

1. Initialize the nodes.

    The following steps must be performed on each of the three nodes, so `ssh` to `kubemaster` and run the steps, then to `kubenode01`, then to `kubenode02`

      1. Configure kernel parameters

            ```
            {
            cat <<EOF | sudo tee /etc/modules-load.d/11-k8s.conf
            br_netfilter
            EOF

            sudo modprobe br_netfilter

            cat <<EOF | sudo tee /etc/sysctl.d/11-k8s.conf
            net.bridge.bridge-nf-call-ip6tables = 1
            net.bridge.bridge-nf-call-iptables = 1
            net.ipv4.ip_forward = 1
            EOF

            sudo sysctl --system
            }
            ```

    1. Install `containerd` container driver and associated tooling

        <details>

        ```bash
        {
            sudo apt update
            sudo apt install -y apt-transport-https ca-certificates curl
            sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
            echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
            sudo apt-get install -y containerd
            #sudo mkdir -p /opt/cni/bin
            #wget -q --https-only \
            #  https://github.com/containernetworking/plugins/releases/download/v0.8.#6/cni-plugins-linux-amd64-v0.8.6.tgz \
            #  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.25.0/#crictl-v1.25.0-linux-amd64.tar.gz
            #sudo tar -xzf cni-plugins-linux-amd64-v0.8.6.tgz -C /opt/cni/bin
            #sudo tar -xzf crictl-v1.25.0-linux-amd64.tar.gz -C /usr/local/bin
        }
        ```

    1. Install Kubernetes software

        <details>
        This will install the latest version

        ```bash
        {
        sudo  curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

        echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.

        sudo apt update

        sudo apt-get install -y kubelet kubeadm kubectl
        sudo apt-mark hold kubelet kubeadm kubectl

        # Configure crictl so it doesn't print ugly warning messages
        sudo crictl config \
            --set runtime-endpoint=unix:///run/containerd/containerd.sock \
            --set image-endpoint=unix:///run/containerd/containerd.sock
        }
        ```

        </details>

  1. Initialize controlplane node

     <details>

      1. Get the IP address of the `eth0` adapter of the controlplane

         ```
         ip addr show dev enp0s8
         ```

         Take the value printed for `inet` in the output. This should be:

         > 192.168.56.11

      1. Create a config file for `kubeadm` to get settings from 

          ```yaml
          kind: ClusterConfiguration
          apiVersion: kubeadm.k8s.io/v1beta3
          kubernetesVersion: v1.25.4          # <- At time of writing. Change as appropriate
          controlPlaneEndpoint: 192.168.56.11:6443
          networking:
            serviceSubnet: "10.96.0.0/16"
            podSubnet: "10.244.0.0/16"
            dnsDomain: "cluster.local"
          controllerManager:
            extraArgs:
              "node-cidr-mask-size": "24"
          apiServer:
            extraArgs:
              authorization-mode: "Node,RBAC"
            certSANs:
              - "192.168.56.11"
              - "kubemaster"
              - "kubernetes"
              
          ---
          kind: KubeletConfiguration
          apiVersion: kubelet.config.k8s.io/v1beta1
          cgroupDriver: systemd
          serverTLSBootstrap: true
          ```

      1. Run `kubeadm init` using the IP address determined above for `--apiserver-advertise-address`

         ```
         sudo kubeadm init \
            --apiserver-cert-extra-sans=kubemaster01 \
            --apiserver-advertise-address 192.168.56.11 \
            --pod-network-cidr=10.244.0.0/16
         ```

         Note the `kubeadm join` command output at the end of this run. You will require it for the step `Initialize the worker nodes` below

      1. Set up the default kubeconfig file

         ```
         {
         mkdir ~/.kube
         sudo cp /etc/kubernetes/admin.conf ~/.kube/config
         sudo chown vagrant:vagrant ~/.kube/config
         }
         ```

     </details>

1. Initialize the worker nodes

    <details>

    The following steps must be performed on both worker nodes, so `ssh` to `kubenode01` and run the steps, then to `kubenode02`

    * Paste the `kubeadm join` command from above step to the command prompt and enter it.

    </details>