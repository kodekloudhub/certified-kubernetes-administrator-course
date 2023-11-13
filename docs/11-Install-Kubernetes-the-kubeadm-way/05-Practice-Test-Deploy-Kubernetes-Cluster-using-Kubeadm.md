# Practice Test - Install kubernetes cluster using kubeadm tool

If you want to build your own cluster, check these out:

* [Kubeadm Clusters](../../kubeadm-clusters/)
* [Managed Clusters](../../managed-clusters/)

# Solutions for KodeKloud lab practice test - Install Using Kubeadm

- Take me to [Practice Test](https://kodekloud.com/topic/practice-test-deploy-a-kubernetes-cluster-using-kubeadm/)

In this practice lab, the container runtime (containerd) has already been installed. We only need to focus on the remaining node configuration, that is the kernel module and parameter settings, and installing the kubeadm cluster itself.

Note that the video preceding this lab is out of date and is still using docker container driver and an out of date Kubernetes version. The lab is up to date.

  1.  <details>
      <summary>Install the kubeadm, kubelet and kubectl packages at exact version 1.24.0 on the controlplane and node01.</summary>

      Run the following two steps on both `controlplane` and `node01` (use `ssh node01` to get to the worker node).

      1. Configure kernel parameters

         ```
         cat <<EOF | tee /etc/modules-load.d/k8s.conf
         overlay
         br_netfilter
         EOF

         cat <<EOF | tee /etc/sysctl.d/k8s.conf
         net.bridge.bridge-nf-call-ip6tables = 1
         net.bridge.bridge-nf-call-iptables = 1
         net.ipv4.ip_forward = 1
         EOF

         sysctl --system
         ```

      2. Install kubernetes binaries

         Note that because you are logged into the lab as `root`, the use of `sudo` is not required.

         ```
         apt-get update
         apt-get install -y apt-transport-https ca-certificates curl

         mkdir -m 755 /etc/apt/keyrings

         curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

         echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

         apt-get update

         # To see the new version labels
         apt-cache madison kubeadm

         apt-get install -y kubelet=1.27.0-2.1 kubeadm=1.27.0-2.1 kubectl=1.27.0-2.1

         apt-mark hold kubelet kubeadm kubectl
         ```
      </details>

  1.  <details>
      <summary>What is the version of kubelet installed?</summary>

      ```
      kubelet version
      ```

      You will get an error message because the cluster isn't installed yet, but it will tell you its version.

      </details>

  1.  <details>
      <summary>How many nodes are part of kubernetes cluster currently?</summary>

      Are you able to run `kubectl get nodes`? Have you run `kubeadm init` yet?

      No, so there are no nodes.

      > 0

      </details>

  1.  Information only

  1.  <details>
      <summary>Initialize Control Plane Node (Master Node).</summary>

      Use the following options:

      * `apiserver-advertise-address` - Use the IP address allocated to eth0 on the controlplane node
      * `apiserver-cert-extra-sans`` - Set it to `controlplane`
      * `pod-network-cidr` - Set to `10.244.0.0/16`

      Once done, set up the default kubeconfig file and wait for node to be part of the cluster.

      1. Get the IP address of the `eth0` adapter of the controlplane

         ```
         ifconfig eth0
         ```

         Take the value printed for `inet` in the output. This will be something like the following, but can be different each time you run the lab.

         > 10.13.26.9

      1. Run `kubeadm init` using the IP address determined above for `--apiserver-advertise-address`

         ```
         kubeadm init \
            --apiserver-cert-extra-sans=controlplane \
            --apiserver-advertise-address 10.13.26.9 \
            --pod-network-cidr=10.244.0.0/16
         ```

      1. Set up the default kubeconfig file

         ```
         mkdir ~/.kube
         cp /etc/kubernetes/admin.conf ~/.kube/config
         ```

      </details>

  1.  <details>
      <summary>Generate a kubeadm join token</summary>

      You can copy the join command output by `kubeadm init` which looks like

      ```
      kubeadm join 10.13.26.9:6443 --token cpwmot.ldhadf3cokvyyx60 \
        --discovery-token-ca-cert-hash sha256:ea3a622922315b14b289c6efd7b1a77cbf81d29f6ddaf03472c304b6d3228c06
      ```

      Note it will be different each time you do the lab.

      </details>

  1.  <details>
      <summary>Join node01 to the cluster using the join token</summary>

      1. `ssh` onto `node01` and paste the join command from above
      1. Return to the controlplane node
      1. Run `kubectl get nodes`. Note that both nodes are `NotReady`. This is OK because we have not yet installed networking.

      </details>

  1.  <details>
      <summary>Install a Network Plugin</summary>

      1. Install flannel

         Click on "Install Netowrk Plugin" tab above the terminal. Find the link to Flannel in the page that comes up

         ```
         kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
         ```

      2. Wait 30 seconds or so, then run `kubectl get nodes`. Nodes should now be ready.

      </details>





