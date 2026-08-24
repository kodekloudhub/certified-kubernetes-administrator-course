# Ingress Annotations and rewrite-target

  - Take me to [Lecture](https://kodekloud.com/topic/ingress-annotations-and-rewrite-target/)

In this section, we will take a look at **Ingress annotations and rewrite-target**

- Different Ingress controllers have different options to customize the way it works. Nginx Ingress Controller has many options but we will take a look into the one of the option "Rewrite Target" option.

> **Fork correction:** the lecture manifest was written against Kubernetes 1.18 using
> `extensions/v1beta1`, which was **removed in 1.22**. Updated below to `networking.k8s.io/v1`. The
> annotations themselves are unchanged — they are nginx-controller features, not API fields, so they
> survive the API version bump untouched. See [FORK-CHANGES.md](../../FORK-CHANGES.md).

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /pay
        pathType: Prefix
        backend:
          service:
            name: pay-service
            port:
              number: 8282
```

#### Capture groups

`rewrite-target: /` discards the matched prefix entirely. To keep part of the path, use a regex path
with a capture group — which requires the `use-regex` annotation:

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  rules:
  - http:
      paths:
      - path: /pay(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: pay-service
            port:
              number: 8282
```

#### The other annotation worth memorising

`nginx.ingress.kubernetes.io/ssl-redirect: "false"` — the KodeKloud labs serve plain HTTP, and without
this the controller answers every request with a 308 redirect to HTTPS.



#### Reference Docs

- https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
- https://kubernetes.github.io/ingress-nginx/examples/
- https://kubernetes.github.io/ingress-nginx/examples/rewrite/
- https://github.com/kubernetes/ingress-nginx/blob/master/docs/troubleshooting.md