# Ingress

  - Take me to [Lecture](https://kodekloud.com/topic/ingress/)

In this section, we will take a look at **Ingress**

- Ingress Controller
- Ingress Resources

## Ingress Controller

- Deployment of **Ingress Controller**

## ConfigMap

```
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-configuration
```

## Deployment

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      serviceAccountName: ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          # Fork correction: quay.io/kubernetes-ingress-controller/... is a dead registry path.
          # The image is now published under registry.k8s.io/ingress-nginx/controller.
          image: registry.k8s.io/ingress-nginx/controller:v1.11.2
          args:
            - /nginx-ingress-controller
            - --configmap=$(POD_NAMESPACE)/nginx-configuration
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
```

## ServiceAccount

- ServiceAccount require for authentication purposes along with correct Roles, ClusterRoles and RoleBindings.

- Create a ingress service account
```
$ kubectl create -f ingress-sa.yaml
serviceaccount/ingress-serviceaccount created
```

## Service Type - NodePort

```
# service-Nodeport.yaml

apiVersion: v1
kind: Service
metadata:
  name: ingress
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress
```

- Create a service
```
$ kubectl create -f service-Nodeport.yaml
```
- To get the service

```
$ kubectl get service
```

## Ingress Resources

> **Fork correction:** every Ingress manifest in this lecture originally used `extensions/v1beta1` with
> `backend.serviceName` / `backend.servicePort`. **That API was removed in Kubernetes 1.22** and is
> rejected by any cluster you will meet today. The current schema is **`networking.k8s.io/v1`**, which:
> requires **`pathType`** on every path, nests the backend under **`backend.service.name`** /
> **`backend.service.port.number`**, renames the top-level `backend:` to **`defaultBackend:`**, and
> selects the controller with **`ingressClassName`** instead of the `kubernetes.io/ingress.class`
> annotation. See [FORK-CHANGES.md](../../FORK-CHANGES.md).

```yaml
# Ingress-wear.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: wear-service
      port:
        number: 80
```

- To create the ingress resource
```
$ kubectl create -f Ingress-wear.yaml
ingress.networking.k8s.io/ingress-wear created
```

- Or imperatively, which is what you want under exam time pressure:
```
$ kubectl create ingress ingress-wear --rule="/wear=wear-service:80"
```

- To get the ingress
```
$ kubectl get ingress
NAME           CLASS    HOSTS   ADDRESS   PORTS   AGE
ingress-wear   <none>   *                 80      18s
```

## Ingress Resource - Rules

- 1 Rule and 2 Paths.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /wear
        pathType: Prefix
        backend:
          service:
            name: wear-service
            port:
              number: 80
      - path: /watch
        pathType: Prefix
        backend:
          service:
            name: watch-service
            port:
              number: 80
```

- Imperative equivalent:
```
$ kubectl create ingress ingress-wear-watch \
    --rule="/wear=wear-service:80" \
    --rule="/watch=watch-service:80"
```

#### `pathType` is mandatory in v1

| value | matches |
| --- | --- |
| `Prefix` | path elements split on `/` — `/wear` matches `/wear` and `/wear/x`, but not `/wearing` |
| `Exact` | the URL path exactly, case sensitive |
| `ImplementationSpecific` | left to the controller. This is what `kubectl create ingress` and auto-converted v1beta1 objects produce |
- Describe the earlier created ingress resource

```
$ kubectl describe ingress ingress-wear-watch
Name:             ingress-wear-watch
Namespace:        default
Address:
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host        Path  Backends
  ----        ----  --------
  *
              /wear    wear-service:80 (<none>)
              /watch   watch-service:80 (<none>)
Annotations:  <none>
Events:
  Type    Reason  Age   From                      Message
  ----    ------  ----  ----                      -------
  Normal  CREATE  23s   nginx-ingress-controller  Ingress default/ingress-wear-watch

```

- 2 Rules and 1 Path each.
```yaml
# Ingress-wear-watch.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  ingressClassName: nginx
  rules:
  - host: wear.my-online-store.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: wear-service
            port:
              number: 80
  - host: watch.my-online-store.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: watch-service
            port:
              number: 80
```

- Host-based rules imperatively:
```
$ kubectl create ingress ingress-wear-watch \
    --rule="wear.my-online-store.com/*=wear-service:80" \
    --rule="watch.my-online-store.com/*=watch-service:80"
```

## IngressClass

In `networking.k8s.io/v1` the controller is chosen by `spec.ingressClassName`, which references an
`IngressClass` object. The old `kubernetes.io/ingress.class` annotation is deprecated.

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"   # used when ingressClassName is omitted
spec:
  controller: k8s.io/ingress-nginx
```

```
$ kubectl get ingressclass
```

If an Ingress has no `ingressClassName` and there is no default IngressClass, **no controller will
pick it up** and it will sit there with no address. That is a common lab failure mode.






> **See also:** the 2025 CKA curriculum adds the **Gateway API** alongside classic Ingress —
> [docs/18-2025-Curriculum-Additions/04-Gateway-API.md](../18-2025-Curriculum-Additions/04-Gateway-API.md).

#### References Docs

- https://kubernetes.io/docs/concepts/services-networking/ingress/
- https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
- https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
- https://thenewstack.io/kubernetes-ingress-for-beginners/