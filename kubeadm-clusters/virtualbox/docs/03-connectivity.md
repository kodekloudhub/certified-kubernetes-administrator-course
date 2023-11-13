# Connectivity

First identify a system from where you will perform administrative tasks, such as creating certificates, kubeconfig files and distributing them to the different VMs.

If you are on a Linux laptop, then your laptop could be this system. In my case I chose the `kubemaster` node to perform administrative tasks. Whichever system you chose make sure that system is able to access all the provisioned VMs through SSH to copy files over.

## Access all VMs

Here we create an SSH key pair for the `vagrant` user who we are logged in as. We will copy the public key of this pair to both workers to permit us to use password-less SSH (and SCP) to get from `kubemaster` to these other nodes in the context of the `vagrant` user which exists on all nodes.

Generate Key Pair on `kubemaster` node

```bash
ssh-keygen
```

Leave all settings to default (just press ENTER at any questions).

View the generated public key ID at:

```bash
cat ~/.ssh/id_rsa.pub
```

Add this key to the local authorized_keys (`kubemaster`)

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

Copy the output from the first `cat` command above into a notepad and form it into the following command

```bash
cat >> ~/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD...OUTPUT-FROM-ABOVE-COMMAND...8+08b vagrant@kubemaster
EOF
```

Now ssh to each of the other nodes and paste the above from your notepad at each command prompt.


Prev: [Compute Resources](02-compute-resources.md)<br>
Next: [Node Setup](./04-node-setup.md)
