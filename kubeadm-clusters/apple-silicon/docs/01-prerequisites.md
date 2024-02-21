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

Next: [Compute Resources](02-compute-resources.md)

