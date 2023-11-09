# Cluster 1, NetPol, cyan-pod-cka28-trb

For this question, please set the context to cluster1 by running:

```
kubectl config use-context cluster1
```

One of the nginx based pod called `cyan-pod-cka28-trb` is running under `cyan-ns-cka28-trb` namespace and it is exposed within the cluster using `cyan-svc-cka28-trb` service.

This is a restricted pod so a network policy called `cyan-np-cka28-trb` has been created in the same namespace to apply some restrictions on this pod.

Two other pods called `cyan-white-cka28-trb1` and `cyan-black-cka28-trb` are also running in the default namespace.

The nginx based app running on the `cyan-pod-cka28-trb` pod is exposed internally on the default nginx port (80).

**Expectation**: This app should only be accessible from the `cyan-white-cka28-trb` pod.

**Problem**: This app is not accessible from anywhere.

Troubleshoot this issue and fix the connectivity as per the requirement listed above.

Note: You can exec into `cyan-white-cka28-trb` and `cyan-black-cka28-trb` pods and test connectivity using the curl utility.

You may update the network policy, but make sure it is not deleted from the `cyan-ns-cka28-trb` namespace.

---

### Update - Intermittent lab bug!

The solution given below is correct, however in some instances it doesn't work due to an intermittent bug in the installation of Weave to the lab environment found by a very astute community member in [this thread](https://kodekloud.com/community/t/network-policy-blocking-all-the-ingress-traffic/300501/15?u=alistair_kodekloud) on the community forum.

TL;DR - To detect the presence of this bug, run the following two commands. Bonus - see if you can understand how they work! Note that the first one is split across multiple lines with `\` for legibility. This is a valid construct in shell script.

```
kubectl exec -n kube-system \
   $(kubectl get po -n kube-system --selector name=weave-net -o jsonpath='{.items[0].metadata.name}') \
   -c weave -- printenv | grep IPALLOC

kubectl get configmap -n kube-system kube-proxy -o jsonpath={'.data.config\.conf}' | yq e .clusterCIDR -
```

Both should report the same CIDR range, e.g. `10.244.0.0/16`. If they are not both the same (doesn't matter what they actually are, but must be the same), then the lab has the bug. Should you encounter this (netpol not working even though you have followed the solution below), then practice your skills of [manual pod scheduling](../../../03-Scheduling/02-Manual-Scheduling.md), and get all three concerned pods to restart on the same worker node (choose either node). Then the netpol should take effect.




### Solution

First, let's examine the policy we have

```
k get netpol -n cyan-ns-cka28-trb cyan-np-cka28-trb -o yaml
```

> Output. (The additional metadata is omitted as it is different every time)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: cyan-np-cka28-trb
  namespace: cyan-ns-cka28-trb
spec:
  egress:
  - ports:
    - port: 8080
      protocol: TCP
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: default
    ports:
    - port: 8080
      protocol: TCP
  podSelector:
    matchLabels:
      app: cyan-app-cka28-trb
  policyTypes:
  - Ingress
  - Egress
status: {}
```

The egress policy you find here is a [red herring](https://dictionary.cambridge.org/dictionary/english/red-herring). Since we are not concerned with egress from the nginx pod, only ingress to it from the other pods, then it does not feature in the solution to this problem so you can ignore it.

There are two issues that need fixing here. You can modify the policy and make both these changes with a single invocation of:

```
kubectl edit netpol -n cyan-ns-cka28-trb cyan-np-cka28-trb
```

1. The reason nothing can connect at the start is that the ingress port 8080 in the netpol is wrong. It should be 80. Why? We are told in the question that the nginx app in the pod to which the policy applies is listening on the default port `80`. Therefore the *ingress* port needs to be `80` and not `8080`. Fix this.
1. Now that’s fixed, everything in default namespace now has access to the pod on port 80, and curl will return the nginx default message. Thus we need to add to the rule a podSelector to ensure the incoming traffic can only come from the nominated pod in the default namespace, so it’s an AND rule.

The finished product is this. Again I have omitted the additional metadata but you can leave it in. Save and exit `vi` so the changes are applied.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: cyan-np-cka28-trb
  namespace: cyan-ns-cka28-trb
spec:
  egress:
  - ports:
    - port: 8080
      protocol: TCP
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: default
      podSelector:      # <- This was added. No dash before podSelector!
        matchLabels:
          app: cyan-white-cka28-trb
    ports:
    - port: 80          # <- This was edited
      protocol: TCP
  podSelector:
    matchLabels:
      app: cyan-app-cka28-trb
  policyTypes:
  - Ingress
  - Egress
```

Note the fact that there must be no `-` before the podSelector that we added. If we put a `-` then the rule would operate as follows

> **ALLOW** any pod in namespace `default` **OR** any pod in any namespace with label `app=cyan-white-cka28-trb`

That would also permit `cyan-black-cka28-trb` to access, which is incorrect! Without the `-`, the rule operates correctly as follows

> **ALLOW** any pod in namespace `default` **THAT HAS** label `app=cyan-white-cka28-trb`

Which basically means pods in namespace `default` **AND** with correct labels.

Let's test this. We will use the `--connect-timeout` argument for `curl` so as not to wait too long for the expected failed connection from the black pod.

```
k exec -n default cyan-white-cka28-trb -it -- curl --connect-timeout 10 cyan-svc-cka28-trb.cyan-ns-cka28-trb.svc
```

> Output

```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
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

```
k exec -n default cyan-black-cka28-trb -it -- curl --connect-timeout 10 cyan-svc-cka28-trb.cyan-ns-cka28-trb.svc
```

> Output

```
curl: (28) Connection timeout after 10000 ms
command terminated with exit code 28
```

White pod connects, black pod does not - RESULT!
