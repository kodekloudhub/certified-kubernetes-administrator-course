# Application Scaling — HPA, VPA and Cluster Autoscaler

> Fork-local note. Not part of the upstream KodeKloud course.
> The Scheduling section stops at requests and limits; the 2025 curriculum expects scaling as well.
> Requires a working metrics-server — see
> [docs/04-Logging-and-Monitoring/02-Monitor-Cluster-Components.md](../04-Logging-and-Monitoring/02-Monitor-Cluster-Components.md).

Three different things, often confused:

| | Changes | Restarts pods |
| --- | --- | --- |
| **HPA** — HorizontalPodAutoscaler | number of replicas | no |
| **VPA** — VerticalPodAutoscaler | requests/limits of each pod | yes (add-on, not built in) |
| **Cluster Autoscaler** | number of **nodes** | no (cloud/provider component) |

Only the HPA is a core API object. The other two are add-ons; know what they do and that they are not
installed by default.

## Prerequisites

HPA reads from the **metrics API**, which means metrics-server must be running:

```bash
kubectl top nodes
kubectl top pods
kubectl get apiservices | grep metrics       # v1beta1.metrics.k8s.io ... True
```

And the target pods **must declare a CPU/memory `request`** — HPA computes utilisation as a percentage
*of the request*. With no request there is nothing to divide by, and the HPA reports
`<unknown>/50%` forever. This is the most common HPA failure.

## Imperative — the exam form

```bash
kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
kubectl get hpa
kubectl get hpa my-app --watch
kubectl describe hpa my-app
kubectl delete hpa my-app
```

## Declarative — `autoscaling/v2`

`autoscaling/v1` only understands CPU. `autoscaling/v2` is the current version and the one to write.

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization        # percentage of the pod's request
          averageUtilization: 50
    - type: Resource
      resource:
        name: memory
        target:
          type: AverageValue       # an absolute quantity, not a percentage
          averageValue: 500Mi
  behavior:                        # optional; controls how aggressively it moves
    scaleDown:
      stabilizationWindowSeconds: 300   # default: wait 5 min before scaling down
      policies:
        - type: Percent
          value: 50
          periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0     # default: scale up immediately
```

With several metrics, the HPA computes a desired replica count for **each** and takes the **highest**.

The arithmetic:

```
desiredReplicas = ceil( currentReplicas × ( currentMetricValue / desiredMetricValue ) )
```

so 4 pods averaging 80% against a 50% target gives `ceil(4 × 80/50)` = 7 replicas. Within a ±10%
tolerance the HPA does nothing.

## HPA and a Deployment's `replicas`

Once an HPA targets a Deployment, **stop setting `replicas` in the Deployment**. `kubectl apply` will
keep resetting the count and fight the HPA. Either drop the field or, better, scale the Deployment
through the HPA only.

`kubectl scale deployment my-app --replicas=5` while an HPA is active works for exactly one
reconcile loop before the HPA overrides it.

## Troubleshooting

```bash
kubectl describe hpa my-app
```

| Condition / target column | Meaning |
| --- | --- |
| `<unknown>/50%` | no metrics — metrics-server down, or **no resource request on the pods** |
| `ScalingActive: False`, `FailedGetResourceMetric` | metrics API unreachable |
| `ScalingLimited: True` | it wants to scale further but has hit `minReplicas`/`maxReplicas` |
| `AbleToScale: False` | the scale subresource of the target is missing or the target does not exist |

## VPA and Cluster Autoscaler, briefly

- **VPA** is installed as CRDs plus three controllers (recommender, updater, admission). Modes:
  `Off` (recommend only), `Initial` (set on creation), `Auto`/`Recreate` (evict and resize).
  Running VPA in `Auto` **and** an HPA on CPU against the same workload conflicts — they fight.
- **Cluster Autoscaler** watches for pods stuck `Pending` with `Insufficient cpu/memory` and asks the
  cloud provider for another node. It scales down nodes that are underutilised and whose pods can move.
  It respects `PodDisruptionBudget`s.

#### K8s Reference Docs
- https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
- https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
- https://kubernetes.io/docs/concepts/workloads/autoscaling/
