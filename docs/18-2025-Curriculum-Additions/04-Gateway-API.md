# Gateway API

> Fork-local note. Not part of the upstream KodeKloud course.
> Covers the CKA competency *"Use the Gateway API to manage Ingress traffic."*
> Companion to the classic [Ingress lecture](../09-Networking/22-Ingress.md), which is still examinable.

Gateway API is the successor to Ingress. It is **not built into Kubernetes** — it ships as a set of
CRDs (`gateway.networking.k8s.io`) plus a controller implementation. Ingress is not deprecated; the
2025 curriculum lists both.

## Why it exists

Ingress put everything in one object owned by one team, and pushed anything it could not express into
controller-specific annotations. Gateway API splits the concern across three roles:

| Resource | Owned by | Answers |
| --- | --- | --- |
| `GatewayClass` | infrastructure provider | *which controller implements this?* (cluster-scoped) |
| `Gateway` | cluster operator | *what listens where — ports, protocol, TLS, hostnames?* |
| `HTTPRoute` | application developer | *what path/header goes to which Service?* |

Routing rules that needed `nginx.ingress.kubernetes.io/*` annotations — header matching, traffic
splitting, request rewriting — are **typed fields** in `HTTPRoute`.

## Install

CRDs first, then a controller that implements them:

```bash
# 1. the API itself (standard channel)
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
kubectl get crd | grep gateway.networking.k8s.io

# 2. an implementation — nginx, Istio, Cilium, Traefik, Envoy Gateway, …
kubectl get gatewayclass
```

If `kubectl get gateway` returns `the server doesn't have a resource type "gateway"`, the CRDs are not
installed. See [03-CRDs-and-Operators](03-CRDs-and-Operators.md).

## The three objects

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx
spec:
  controllerName: gateway.nginx.org/nginx-gateway-controller
```

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: prod-gateway
  namespace: infra
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces:
          from: All        # All | Same | Selector — this is the cross-namespace control
    - name: https
      protocol: HTTPS
      port: 443
      hostname: "*.example.com"
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: example-com-tls
```

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: store
  namespace: app-space
spec:
  parentRefs:
    - name: prod-gateway
      namespace: infra          # attaching to a Gateway in another namespace
  hostnames:
    - "shop.example.com"
  rules:
    - matches:
        - path:
            type: PathPrefix    # PathPrefix | Exact | RegularExpression
            value: /wear
      backendRefs:
        - name: wear-service
          port: 8080
    - matches:
        - path:
            type: PathPrefix
            value: /watch
      backendRefs:              # traffic splitting is a first-class field, no annotations
        - name: video-service
          port: 8080
          weight: 90
        - name: video-canary
          port: 8080
          weight: 10
    - matches:
        - headers:
            - name: x-canary
              value: "true"
      filters:
        - type: RequestRedirect
          requestRedirect:
            scheme: https
            statusCode: 301
      backendRefs:
        - name: canary-service
          port: 8080
```

## Ingress → Gateway API translation

| Ingress | Gateway API |
| --- | --- |
| `ingressClassName` | `Gateway.spec.gatewayClassName` |
| `spec.rules[].host` | `HTTPRoute.spec.hostnames` (or a listener `hostname`) |
| `pathType: Prefix` | `matches[].path.type: PathPrefix` |
| `backend.service.name/port.number` | `backendRefs[].name` / `.port` |
| `spec.tls[]` | `Gateway.spec.listeners[].tls.certificateRefs` |
| `rewrite-target` annotation | `filters[].type: URLRewrite` |
| canary-weight annotations | `backendRefs[].weight` |
| — (impossible) | header/method/query matching, cross-namespace routing, `ReferenceGrant` |

## Cross-namespace rules

An `HTTPRoute` may attach to a `Gateway` in another namespace only if that Gateway's listener
`allowedRoutes` permits it. A route referencing a **backend Service** in a different namespace
additionally needs a `ReferenceGrant` in the *backend's* namespace. This is the deliberate
security-boundary difference from Ingress, and the most likely thing to be tested.

## Troubleshooting

```bash
kubectl get gatewayclass                       # ACCEPTED=True means a controller claimed it
kubectl get gateway -A                         # PROGRAMMED=True and an ADDRESS means it is live
kubectl describe gateway prod-gateway -n infra # listener conditions: Accepted, ResolvedRefs
kubectl describe httproute store -n app-space  # parents[].conditions — Accepted / ResolvedRefs
```

`ResolvedRefs: False` on an HTTPRoute almost always means the backend Service name or port is wrong, or
a cross-namespace reference lacks a `ReferenceGrant`. `Accepted: False` on the parent means the Gateway
refused the attachment — check `allowedRoutes` and the hostname intersection.

#### K8s Reference Docs
- https://kubernetes.io/docs/concepts/services-networking/gateway/
- https://gateway-api.sigs.k8s.io/
- https://gateway-api.sigs.k8s.io/guides/migrating-from-ingress/
