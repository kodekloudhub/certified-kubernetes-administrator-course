# Dynamic Volume Provisioning

> Fork-local note. Not part of the upstream KodeKloud course.
> Depth added on top of [docs/08-Storage/12-Storage-Class.md](../08-Storage/12-Storage-Class.md), which
> introduces StorageClass but stops before reclaim policies, binding modes and expansion — all of which
> the 2025 Storage domain leans on.

**Static provisioning:** an admin creates PersistentVolumes by hand; a PVC binds to whichever one fits.
**Dynamic provisioning:** the PVC names a `StorageClass`, and a CSI driver creates the PV on demand.

```
PVC (storageClassName: fast)
  └─> StorageClass "fast" (provisioner: ebs.csi.aws.com)
        └─> CSI driver CreateVolume
              └─> PV created and Bound automatically
```

## StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com          # the CSI driver name; kubernetes.io/no-provisioner = static only
parameters:                           # driver-specific, not validated by Kubernetes
  type: gp3
  encrypted: "true"
reclaimPolicy: Delete                 # Delete (default) | Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

`provisioner`, `parameters` and `reclaimPolicy` are **immutable** once created. Changing them means
deleting and recreating the class — existing PVs keep the policy they were created with.

## `volumeBindingMode` — the one that catches people

| Mode | When the PV is created and bound |
| --- | --- |
| `Immediate` (default) | as soon as the PVC is created |
| `WaitForFirstConsumer` | not until a **Pod** using the PVC is scheduled |

`Immediate` on a topology-constrained backend (zonal disks, `local` volumes) provisions the volume
somewhere the pod may not be able to run, and the pod then sits `Pending` forever with
`node(s) had volume node affinity conflict`. `WaitForFirstConsumer` lets the scheduler pick the node
first and provision to match.

The visible symptom of `WaitForFirstConsumer` working normally is a PVC sitting in `Pending` with
`waiting for first consumer to be created before binding` — **that is not an error.**

## `reclaimPolicy` — what happens when the PVC is deleted

| Policy | Effect on PV deletion | Set on |
| --- | --- | --- |
| `Delete` | PV **and the backing volume** are destroyed | default for dynamic |
| `Retain` | PV goes to `Released`, data kept, **not reusable until an admin clears `spec.claimRef`** | default for static |
| `Recycle` | deprecated, removed — do not use | — |

A `Released` PV is not automatically available to a new PVC. To reuse it:

```bash
kubectl patch pv <pv-name> -p '{"spec":{"claimRef": null}}'   # -> Available
```

Change the policy on an existing PV:

```bash
kubectl patch pv <pv-name> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
```

## Access modes and volume modes

| Access mode | Short | Meaning |
| --- | --- | --- |
| `ReadWriteOnce` | RWO | read-write by pods on **one node** |
| `ReadOnlyMany` | ROX | read-only from many nodes |
| `ReadWriteMany` | RWX | read-write from many nodes — needs a file backend (NFS, CephFS); block devices cannot do this |
| `ReadWriteOncePod` | RWOP | read-write by exactly **one pod** |

A PVC binds only to a PV that offers **at least** the requested access mode and capacity.
`volumeMode: Filesystem` (default) vs `Block` (raw device, no filesystem).

## Expanding a volume

Only if the StorageClass has `allowVolumeExpansion: true`, and only **larger**:

```bash
kubectl patch pvc my-claim -p '{"spec":{"resources":{"requests":{"storage":"20Gi"}}}}'
kubectl get pvc my-claim -o jsonpath='{.status.capacity.storage}'
```

Some drivers need the pod restarted to finish the filesystem resize — watch for the
`FileSystemResizePending` condition on the PVC.

## Default StorageClass

A PVC that omits `storageClassName` gets the class annotated
`storageclass.kubernetes.io/is-default-class: "true"`. A PVC with `storageClassName: ""` (explicit
empty string) opts **out** of dynamic provisioning entirely and will only bind to a matching static PV.

```bash
kubectl get sc                       # the default is marked (default)
kubectl patch storageclass standard \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```

More than one default is a misconfiguration — provisioning becomes non-deterministic.

## Troubleshooting

```bash
kubectl get pvc,pv
kubectl describe pvc my-claim        # events name the exact reason
kubectl get sc
kubectl get events --sort-by=.lastTimestamp
```

| PVC state / message | Cause |
| --- | --- |
| `Pending` + `waiting for first consumer` | normal for `WaitForFirstConsumer` — create the pod |
| `Pending` + `no persistent volumes available for this claim` | static provisioning and nothing matches size / access mode / `storageClassName` |
| `Pending` + `storageclass.storage.k8s.io "fast" not found` | typo, or the class was deleted |
| `Pending` with no events at all | no default StorageClass and none named |
| Pod `Pending`, `volume node affinity conflict` | PV provisioned in a zone/node the pod cannot reach — wanted `WaitForFirstConsumer` |
| PV stuck `Terminating` | a pod still mounts it, or the `kubernetes.io/pv-protection` finalizer |
| PVC stuck `Terminating` | `kubernetes.io/pvc-protection` — a pod is still using it |

`Bound` on both sides is the only healthy steady state. Match capacity, access mode **and**
`storageClassName` before looking anywhere else.

#### K8s Reference Docs
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- https://kubernetes.io/docs/concepts/storage/storage-classes/
- https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/
