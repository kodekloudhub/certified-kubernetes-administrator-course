# Server for testing network policies

Sometimes you may have a question that asks you to block ingress to a pod on all but some specific port. If a pod that meets the port requirement is not already present in the given namespace, then the issue here is "How do I create a pod onto which to attach the netpol that listens on the given port so I can test the policy?". You can't just run an nginx pod as that always listens on port 80. You could configure it otherwise, but that would require you to mount a configmap into the nginx pod containing an alternate config for nginx with the new port number. That's far too much hassle under exam conditions!

Fortunately, the default Python distribution contains a simple server that can have its port number configured from the command line, meaning you can run it imperatively. Let's say the network policy requires blocking all but port 9000. We can start a server test pod to listen on 9000 like so. If it's a different port, just put that port number instead of 9000.

```
kubectl run server --image python --command -- python -m http.server 9000
```

Get the pod's IP address. Using the IP for curl test is quicker than typing out the DNS name.

```
controlplane $ k get pod server -o wide
NAME     READY   STATUS    RESTARTS   AGE   IP             NODE     NOMINATED NODE   READINESS GATES
server   1/1     Running   0          16s   192.168.1.12   node01   <none>           <none>
```

Now run a pod with `curl` in and test connection to the server

```
curl 192.168.1.12:9000
```

You should get a response.

Now apply your network policy and test again.

See also [client for testing](./02-client--for-testing-network-things.md)

