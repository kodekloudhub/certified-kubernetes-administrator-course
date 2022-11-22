# Practice Test - Install kubernetes cluster using kubeadm tool

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-deploy-a-kubernetes-cluster-using-kubeadm/)

# Solutions for practice test - Install Using Kubeadm

  1. Install the kubeadm, kubelet and kubectl packages at exact version 1.24.0 on the controlplane and node01.

     <details>

     Run the following two steps on both `controlplane` and `node01` (use `ssh node01` to get to the worker node).

      1. Configure kernel parameters

         ```
         cat <<EOF | tee /etc/modules-load.d/k8s.conf
         br_netfilter
         EOF

         cat <<EOF | tee /etc/sysctl.d/k8s.conf
         net.bridge.bridge-nf-call-ip6tables = 1
         net.bridge.bridge-nf-call-iptables = 1
         EOF
         sysctl --system
         ```

      2. Install kubernetes binaries

         ```
         apt-get update
         apt-get install -y apt-transport-https ca-certificates curl

         curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

         echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

         apt-get update
         apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00
         apt-mark hold kubelet kubeadm kubectl
         ```
     </details>

  1. What is the version of kubelet installed?

     <details>

      ```
      kubelet --version
      ```
     </details>

  1. How many nodes are part of kubernetes cluster currently?

     <details>

      Are you able to run `kubectl get nodes`?

      Know that the kubeconfig file installed by kubeadm is located in `/etc/kubernetes/admin.conf`

      ```
      kubectl get nodes --kubeconfig /etc/kubernetes/admin.conf
      ```

      > 0

     </details>

  1. Information only

  1. Initialize controlplane node

     <details>

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

  1. Generate a kubeadm join token

      <details>

      You can copy the join command output by `kubeadm init` which looks like

      ```
      kubeadm join 10.13.26.9:6443 --token cpwmot.ldhadf3cokvyyx60 \
        --discovery-token-ca-cert-hash sha256:ea3a622922315b14b289c6efd7b1a77cbf81d29f6ddaf03472c304b6d3228c06
      ```

      Note it will be different each time you do the lab.

      </details>

  1. Join node01 to the cluster using the join token

      <details>

      1. `ssh` onto `node01` and paste the join command from above
      1. Return to the controlplane node
      1. Run `kubectl get nodes`. Note that both nodes are `NotReady`. This is OK because we have not yet installed networking.

      </details>

  1. Install a Network Plugin

     <details>

      1. Install flannel

         ```
         kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
         ```

      2. Wait 30 seconds or so, then run `kubectl get nodes`. Nodes should now be ready.

     </details>





