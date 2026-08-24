# Custom Resource Definitions and Operators

> Fork-local note. Not part of the upstream KodeKloud course.
> Covers the CKA competency *"Understand extension interfaces… CRDs, install and configure operators."*

A **CustomResourceDefinition** teaches the API server a new kind. That is *all* it does — it gives you
storage, validation and `kubectl` support for a new object type. Nothing happens when you create one of
those objects unless a **controller** is watching for them.

**Operator = CRD + controller.** The controller runs a reconcile loop: read desired state from the
custom resource, compare against the world, act, write `status` back.

## Defining a CRD

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.stable.example.com      # MUST be <plural>.<group>
spec:
  group: stable.example.com
  scope: Namespaced                     # or Cluster
  names:
    plural: backups
    singular: backup
    kind: Backup
    shortNames: [bk]
  versions:
    - name: v1
      served: true                      # is this version reachable over the API
      storage: true                     # exactly ONE version may be the storage version
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              required: [source]
              properties:
                source:
                  type: string
                retentionDays:
                  type: integer
                  minimum: 1
                  default: 7
      subresources:
        status: {}                      # enables /status as a separate write path
      additionalPrinterColumns:
        - name: Source
          type: string
          jsonPath: .spec.source
```

A schema is **mandatory** in `apiextensions.k8s.io/v1` — the old schemaless `v1beta1` CRD API was
removed in Kubernetes 1.22, same release as the old Ingress API.

An instance is then ordinary YAML:

```yaml
apiVersion: stable.example.com/v1
kind: Backup
metadata:
  name: nightly
spec:
  source: /var/lib/data
  retentionDays: 30
```

## Working with them

```bash
kubectl get crd
kubectl get crd backups.stable.example.com -o yaml
kubectl api-resources --api-group=stable.example.com
kubectl api-versions | grep stable.example.com
kubectl explain backup.spec                  # works for CRDs too, generated from the schema
kubectl get backups -A
kubectl describe backup nightly
```

`kubectl api-resources` is the fastest answer to "what custom kinds does this cluster have, are they
namespaced, and what are their short names."

## Installing an operator

Three shapes, in rough order of how often you meet them:

1. **A plain manifest bundle** — `kubectl apply -f https://.../operator.yaml`. Creates the CRDs, a
   Namespace, a ServiceAccount, RBAC, and a Deployment running the controller.
2. **A Helm chart** — see [01-Helm](01-Helm.md). Note that charts install CRDs from a `crds/`
   directory which Helm **never upgrades or deletes**; CRD upgrades stay a manual step.
3. **Operator Lifecycle Manager (OLM)** — `Subscription` / `ClusterServiceVersion` objects. Common on
   OpenShift, rare on vanilla clusters.

Order matters: **the CRD must exist before any custom resource that references it**. Applying a
directory where the CR sorts before the CRD fails with `no matches for kind`. Apply the CRD, wait, then
the CR:

```bash
kubectl wait --for=condition=Established crd/backups.stable.example.com --timeout=60s
```

## Troubleshooting

| Symptom | Cause |
| --- | --- |
| `the server doesn't have a resource type "backup"` | CRD not installed, or wrong group/plural |
| `no matches for kind "Backup" in version "…/v1"` | that version is not `served`, or the CRD is not Established yet |
| CR created but nothing happens | the **controller** is missing or crash-looping — `kubectl get pods -n <operator-ns>`, then `kubectl logs` |
| Controller pod `Running` but idle | RBAC. Its ServiceAccount cannot get/watch the CR: `kubectl auth can-i list backups --as=system:serviceaccount:<ns>:<sa>` |
| Deletion hangs forever | a **finalizer** on the CR whose controller is gone — inspect `metadata.finalizers` |
| `spec.retentionDays: Invalid value` on apply | the OpenAPI schema rejected it; read the schema with `kubectl explain` |

Deleting a CRD deletes **every object of that kind, cluster-wide**, with no confirmation prompt.

#### K8s Reference Docs
- https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/
- https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
- https://kubernetes.io/docs/concepts/extend-kubernetes/operator/
