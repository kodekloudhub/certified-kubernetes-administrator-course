# Cluster 3 - External Webserver

NOTE: This question is also present in the Ultimate CKAD Mocks. The service name is `external-webserver-ckad01-svcn`, however the solution is exactly the same. If you are doing the CKAD version of this question, put instead `external-webserver-ckad01-svcn` everywhere you see `external-webserver-cka03-svcn`.

For this question, please set the context to cluster3 by running:

```
kubectl config use-context cluster3
```


We have an **external** webserver running on `student-node` which is exposed at port `9999`. We have created a service called `external-webserver-cka03-svcn` that can connect to our local webserver from within the kubernetes cluster3 but at the moment it is not working as expected.

Fix the issue so that other pods within cluster3 can use `external-webserver-cka03-svcn` service to access the webserver.

---

For this we are told that we need to wire up the service to a web server that's running on `student-node` at port `9999`. Let's verify this. On student node run the following

```
curl localhost:9999
```

> Output

```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

Yup, it's there!

The important thing to note is that this web server is *outside* of the cluster, therefore the service is going to need to talk to an IP which is not inside the cluster, it is in fact the primary IP address of `student-node`. Let's find that by running the following on `student-node`:

```
ifconfig
```

> Output (note that the values you get for each interface will almost certainly be different)

```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet 192.37.66.3  netmask 255.255.255.0  broadcast 192.37.66.255
        ether 02:42:c0:25:42:03  txqueuelen 0  (Ethernet)
        RX packets 2179  bytes 713082 (713.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2361  bytes 391620 (391.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.25.0.103  netmask 255.255.255.0  broadcast 172.25.0.255
        ether 02:42:ac:19:00:67  txqueuelen 0  (Ethernet)
        RX packets 36  bytes 8457 (8.4 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 14  bytes 1593 (1.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 161  bytes 14395 (14.3 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 161  bytes 14395 (14.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

The primary interface is `eth0`. Note down the `inet` value for this interface which in this example is `192.37.66.3`. This is the IP address that our service needs to talk to.

If we now do a `kubectl get service` on `external-webserver-cka03-svcn`, we see there's no pod selector and therefore no endpoints. So isn't "working as expected" since it doesn't have any endpoints.

To wire up the service to the external IP, we must explicitly create an endpoint for the service. Note that the name of the endpoint (`metadata.name`) *must exactly match* the name of the service that you want to associate it to. Here's the endpoint with comments indicating what's what.

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: external-webserver-cka03-svcn  # <- Must be same name as the service to associate with
  namespace: default
subsets:
  - addresses:
      - ip: 192.37.66.3  # <- We got this from ifconfig
    ports:
      - port: 9999       # <- Given in the question
```

Create this in a file and `kubectl apply` it.

Now let's test it using a `wbitt/network-multitool` pod that will contain curl so that we can call the service.<br/> TIP - remember this image! It contains many common networking and DNS tools that can be useful in troubleshooting - and yes it can be used in the real exam.

```
k run test-pod --image wbitt/network-multitool --restart Never -it -- curl external-webserver-cka03-svcn.default.svc
```

> Output

```
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - test-pod - 10.42.0.13 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

We got a response - RESULT!

So what we have achieved here is to configure a ClusterIP service that allows pods *inside* the cluster to talk to a service that is *outside* the cluster by way of an explicit endpoint that points to an external IP address. `kube-proxy` takes care of the routing for us.