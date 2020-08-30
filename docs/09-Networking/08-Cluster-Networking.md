# Pre-requisite Cluster Networking

  - Take me to [Lecture](https://kodekloud.com/courses/539883/lectures/9808288)


## IP and Hostname

- To view the hostname

```
$ hostname 
```

- To view the IP addr of the system

```
$ ip a
```


## Set the hostname

```
$ hostnamectl set-hostname <host-name>

$ exec bash
```

## View the Listening Ports of the system

```
$ netstat -nltp
```



#### References Docs

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
