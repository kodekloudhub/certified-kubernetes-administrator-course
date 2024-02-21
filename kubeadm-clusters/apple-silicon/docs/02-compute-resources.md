# Compute Resources

Because we cannot use VirtualBox and are instead using Multipass, [a script is provided](./deploy-virtual-machines.sh) to create the three VMs.

1. Run the VM deploy script from your Mac terminal

    ```bash
    ./deploy-virtual-machines.sh
    ```

2. Verify you can connect to all three (two if your Mac only has 8GB RAM) VMs:

    ```bash
    multipass shell controlplane
    ```

    You should see a command prompt like `ubuntu@controlplane:~$`

    Type the following to return to the Mac terminal

    ```bash
    exit
    ```

    Do this for `node01` and `node02` as well

Prev: [Prerequisites](./01-prerequisites.md)<br>
Next: [Connectivity](./03-connectivity.md)