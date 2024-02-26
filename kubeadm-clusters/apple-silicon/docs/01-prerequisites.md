# Prerequisites

* Apple Silicon System (M1/M2/M3 etc)
* 8GB RAM (16GB preferred).
    * All configurations - One control plane node will be provisioned - `controlplane`
    * If you have less than 16GB then only one worker node will be provisioned - `node01`
    * If you have 16GB or more then two workers will be provisioned - `node01` and `node02`

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
We have pre-set an environment variable `PRIMARY_IP` on all VMs which is the IP address that kube components should be using. `PRIMARY_IP` is defined as the IP address of the network interface on the node that is connected to the network having the default gateway, and is the interface that a node will use to talk to the other nodes. For those interested, this variable is assigned the result of the following command

```bash
ip route | grep default | awk '{ print $9 }'
```

Next: [Compute Resources](02-compute-resources.md)

