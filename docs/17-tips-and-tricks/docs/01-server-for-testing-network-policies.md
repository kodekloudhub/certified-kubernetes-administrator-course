# Servers for testing network policies

Sometimes you may have a question that asks you to block ingress to a pod on all but some specific port. If a pod that meets the port requirement is not already present in the given namespace, then the issue here is "How do I create a pod onto which to attach the netpol that listens on the given port so I can test the policy?". You can't just run an nginx pod as that always listens on port 80. You could configure it otherwise, but that would require you to mount a configmap into the nginx pod containing an alternate config for nginx with the new port number. That's far too much hassle under exam conditions!

## Simple server

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

## Slightly more advanced server

Perhaps you want to set up several pods and have each serve a specific message on a configurable port so you can tell them apart by their reponses. We can do that with a pod and a config map for each. The pod is the same each time - except for giving it a unique name and mounting the appropriate config map.

The following simulates a pod found in one of the Killer.sh network policy questions.

1. Create a config map which contains a shell script to run the server on a given port with a given message

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
    name: db1-configmap
    data:
    entrypoint.sh: |
      #!/bin/sh
      echo "database one" > index.htm  #<- Message
      port=1111                        #<- Server Port
      # Run server...
      while true
      do
          { echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c <index.htm)\r\n\r\n"; cat index.htm; } | nc -l -p $port
      done
    ```
1. Create a pod that mounts the configmap and runs the script it contains

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
    name: db-1
    spec:
    containers:
    - name: server
        image: alpine:3.19
        command:
        - /opt/server/entrypoint.sh
        volumeMounts:
        - name: script
        mountPath: /opt/server
    volumes:
    - name: script
        configMap:
        name: db1-configmap
        defaultMode: 0755
    ```
1. Get the pod's IP address. Using the IP for curl test is quicker than typing out the DNS name.

    ```
    controlplane $ k get pod server -o wide
    NAME     READY   STATUS    RESTARTS   AGE   IP             NODE     NOMINATED NODE   READINESS GATES
    db-1     1/1     Running   0          16s   192.168.1.12   node01   <none>           <none>
    ```

1. Now run a pod with `curl` in and test connection to the server

    ```
    curl 192.168.1.12:1111
    ```


## See also

See also [client for testing](./02-client--for-testing-network-things.md)

