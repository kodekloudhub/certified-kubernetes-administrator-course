# Practice Test - CNI weave

  - Take me to [Practice Test](https://kodekloud.com/topic/practice-test-cni-weave/)

#### Solution

  1. <details>
      <summary>Inspect the kubelet service and identify the container runtime value is set for Kubernetes.</summary>

      Check kubelet unit file

      ```bash
      systemctl cat kubelet
      ```

      Note from the output this line

      ```
      EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
      ```

      Inspect this file

      ```bash
      cat /var/lib/kubelet/kubeadm-flags.env
      ```

      Answer can be found as value of `--container-runtime`

      > REMOTE

      </details>

  2. <details>
      <summary>What is the path configured with all binaries of CNI supported plugins?</summary>

      This is the standard location for the installation of CNI plugins

      | `/opt/cni/bin`

     </details>

  3. <details>
      <summary>Identify which of the below plugins is not available in the list of available CNI plugins on this host?</summary>

      ```bash
      ls -l /opt/cni/bin
      ```

      Find the option from the given answers not in the output opf the above

      > cisco

     </details>

  4. <details>
      <summary>What is the CNI plugin configured to be used on this kubernetes cluster?</summary>

      From the available options, we need to recognise which of the four is not the name of a container networking provider. Of the three that are, only one of them is present in `/opt/cni/bin`

      > flannel

      Note that `bridge` is a mechanism for connecting networks together, and not a network _provider_.
     </details>

  5. <details>
      <summary>What binary executable file will be run by kubelet after a container and its associated namespace are created.</summary>

      Following on from Q4...

      > flannel

      All the files in `/opt/cni/bin` are binary executables with tasks related to configuring network namespaces. After the network namespace is configured using the other programs, `flannel` implements the network.

      [This is a great article](https://tonylixu.medium.com/k8s-network-cni-introduction-b035d42ad68f) on what the programs in `/opt/cni/bin` are for.
     </details>

