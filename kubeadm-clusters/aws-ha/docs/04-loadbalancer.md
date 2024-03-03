# Configure the load balancer

Now we will install the load balancer that serves as the endpoint for connecting to API server. This will round-robin API server requests between each of the control plane nodes. For this we will use [HAProxy](https://haproxy.org/) in TCP load balancing mode. In this mode it simply forwards all traffic to its back ends (the control planes) without changing it e.g. doing SSL termination.

First, be logged into `student-node` as directed above.

1.  Log into the load balancer

    ```
    ssh loadbalancer
    ```

1. Become root (saves typing `sudo` before every command)

    ```bash
    sudo -i
    ```

1. Update the apt package index and install packages needed for HAProxy:

    ```bash
    apt-get update
    apt-get install -y haproxy
    ```

1.  Get IP addresses of the loadbalancer and 3 control planes and copy them to your notepad

    ```bash
    dig +short loadbalancer
    dig +short controlplane01
    dig +short controlplane02
    dig +short controlplane03
    ```

1.  Create the HAProxy configuration file

    First we'll delete the default configuration, then add our own

    ```
    rm /etc/haproxy/haproxy.cfg
    vi /etc/haproxy/haproxy.cfg
    ```

    Now put the following content into the file. Replace `L.L.L.L` with the IP address of `loadbalancer`, and `X.X.X.X` with IPs for each control plane node

    ```
    frontend kubernetes
        bind L.L.L.L:6443
        option tcplog
        mode tcp
        default_backend kubernetes-control-nodes

    backend kubernetes-control-nodes
        mode tcp
        balance roundrobin
        option tcp-check
        server controlplane01 X.X.X.X:6443 check fall 3 rise 2
        server controlplane02 X.X.X.X:6443 check fall 3 rise 2
        server controlplane03 X.X.X.X:6443 check fall 3 rise 2
    ```

1.  Restart and check haproxy

    ```bash
    systemctl restart haproxy
    systemctl status haproxy
    ```

    It should be warning us that no backend is available - which is true because we haven't installed Kubernetes yet!

1.  Exit from `sudo` and then back to `student-node`

    ```bash
    exit
    exit
    ```

Next: [Node Setup](./04-loadbalancer.md)<br>
Prev: [Connectivity](./03-connectivity.md)
