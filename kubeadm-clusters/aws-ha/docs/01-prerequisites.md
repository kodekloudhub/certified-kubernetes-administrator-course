# Prerequisites

* Access to an AWS Account. Either [KodeKloud Playground](https://kodekloud.com/topic/playground-aws/), or your own.

We have pre-set an environment variable `PRIMARY_IP` on all VMs which is the IP address that kube components should be using. `PRIMARY_IP` is defined as the IP address of the network interface on the node that is connected to the network having the default gateway, and is the interface that a node will use to talk to the other nodes. For those interested, this variable is assigned the result of the following command

```bash
ip route | grep default | awk '{ print $9 }'
```


Next: [Compute Resources](02-compute-resources.md)

