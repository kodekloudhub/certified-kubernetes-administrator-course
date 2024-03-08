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

1.  Using the [dig](https://linux.die.net/man/1/dig) command which is an alternative to `nslookup` and better for scripting with, we can get the *private* IP addresses of the loadbalancer and 3 control planes.

    ```bash
    dig +short loadbalancer
    dig +short controlplane01
    dig +short controlplane02
    dig +short controlplane03
    ```

    **Terminology**

    AWS EC2 instances effectively have two IP addresses:
    1. Private IP - This is the IP on the AWS subnet where the instance is launched, and is used for EC2 instances to talk to each other.
    1. Public IP - Not always assigned, but is the IP used to reach the EC2 instances from the outside world (i.e. your browser). We will see this later in the testing section.

1.  Create the HAProxy configuration file

    ```bash
    cat <<EOF > /etc/haproxy/haproxy.cfg
    frontend kubernetes
        bind $(dig +short loadbalancer):6443
        option tcplog
        mode tcp
        default_backend kubernetes-control-nodes

    backend kubernetes-control-nodes
        mode tcp
        balance roundrobin
        option tcp-check
        server controlplane01 $(dig +short controlplane01):6443 check fall 3 rise 2
        server controlplane02 $(dig +short controlplane02):6443 check fall 3 rise 2
        server controlplane03 $(dig +short controlplane03):6443 check fall 3 rise 2
    EOF
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

Next: [Node Setup](./05-node-setup.md)<br>
Prev: [Connectivity](./03-connectivity.md)
