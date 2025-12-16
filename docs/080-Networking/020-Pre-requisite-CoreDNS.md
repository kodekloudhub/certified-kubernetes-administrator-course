# Pre-requisite CoreDNS

  - Take me to [Lecture](https://kodekloud.com/topic/prerequisite-coredns/)

In this section, we will take a look at **CoreDNS**

## Installation of CoreDNS

```
$ wget https://github.com/coredns/coredns/releases/download/v1.7.0/coredns_1.7.0_linux_amd64.tgz
coredns_1.7.0_linux_amd64.tgz

```

## Extract tar file

```
$ tar -xzvf coredns_1.7.0_linux_amd64.tgz
coredns
```

## Run the executable file

- Run the executable file to start a DNS server. By default, it's listen on port 53, which is the default port for a DNS server.

```
$ ./coredns

```

## Configuring the hosts file

- Adding entries into the `/etc/hosts` file.
- CoreDNS will pick the ips and names from the `/etc/hosts` file on the server.

```
$ cat > /etc/hosts
192.168.1.10    web
192.168.1.11    db
192.168.1.15    web-1
192.168.1.16    db-1
192.168.1.21    web-2
192.168.1.22    db-2
```

## Adding into the Corefile

```
$ cat > Corefile
. {
	hosts   /etc/hosts
}

```

## Run the executable file

```
$ ./coredns

```


#### References Docs

- https://github.com/kubernetes/dns/blob/master/docs/specification.md
- https://coredns.io/plugins/kubernetes/
- https://github.com/coredns/coredns/releases