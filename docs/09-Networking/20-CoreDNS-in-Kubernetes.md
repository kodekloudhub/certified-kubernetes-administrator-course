# CoreDNS in Kubernetes

  - Take me to [Lecture](https://kodekloud.com/courses/certified-kubernetes-administrator-with-practice-tests/lectures/9808285)

In this section, we will take a look at **CoreDNS in the Kubernetes**


## To view the Pod

```
$ kubectl get pods -n kube-system
NAME                                      READY   STATUS    RESTARTS   AGE
coredns-66bff467f8-2vghh                  1/1     Running   0          53m
coredns-66bff467f8-t5nzm                  1/1     Running   0          53m
```

## To view the Deployment

```
$ kubectl get deployment -n kube-system
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
coredns                   2/2     2            2           53m
```

## To view the configmap of CoreDNS

```
$ kubectl get configmap -n kube-system
NAME                                 DATA   AGE
coredns                              1      52m
```

## CoreDNS Configuration File

```
$ kubectl describe cm coredns -n kube-system

Corefile:
---
.:53 {
    errors
    health {       lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
}
```

## To view the Service 

```
$ kubectl get service -n kube-system
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   62m
```

## To view Configuration into the kubelet 

```
$ cat /var/lib/kubelet/config.yaml | grep -A2  clusterDNS
clusterDNS:
- 10.96.0.10
clusterDomain: cluster.local

```

## To view the fully qualified domain name

- With the `host` command, we will get fully qualified domain name (FQDN).

```
$ host web-service
web-service.default.svc.cluster.local has address 10.106.112.101

$ host web-service.default
web-service.default.svc.cluster.local has address 10.106.112.101

$ host web-service.default.svc
web-service.default.svc.cluster.local has address 10.106.112.101

$ host web-service.default.svc.cluster.local
web-service.default.svc.cluster.local has address 10.106.112.101
```

## To view the `/etc/resolv.conf` file

```
$ kubectl run -it --rm --restart=Never test-pod --image=busybox -- cat /etc/resolv.conf
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
pod "test-pod" deleted
```

## Resolve the Pod 

```
$ kubectl get pods -o wide
NAME      READY   STATUS    RESTARTS   AGE     IP           NODE     NOMINATED NODE   READINESS GATES
test-pod   1/1     Running   0          11m     10.244.1.3   node01   <none>           <none>
nginx      1/1     Running   0          10m     10.244.1.4   node01   <none>           <none>

$ kubectl exec -it test-pod -- nslookup 10-244-1-4.default.pod.cluster.local
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      10-244-1-4.default.pod.cluster.local
Address 1: 10.244.1.4 
```

## Resolve the Service

```
$ kubectl get service
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP   85m
web-service   ClusterIP   10.106.112.101   <none>        80/TCP    9m

$ kubectl exec -it test-pod -- nslookup web-service.default.svc.cluster.local
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-service.default.svc.cluster.local
Address 1: 10.106.112.101 web-service.default.svc.cluster.local

```


#### References Docs

- https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#services
- https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pods
