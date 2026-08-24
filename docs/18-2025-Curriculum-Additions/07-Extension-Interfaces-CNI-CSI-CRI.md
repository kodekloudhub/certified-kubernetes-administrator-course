# Extension Interfaces — CRI, CNI, CSI

> Fork-local note. Not part of the upstream KodeKloud course.
> Covers the CKA competency *"Understand extension interfaces (CNI, CSI, CRI, etc.)."*
> The upstream notes cover CNI well, CSI thinly, and CRI only inside
> [02-Core-Concepts/03-Docker-vs-ContainerD.md](../02-Core-Concepts/03-Docker-vs-ContainerD.md)
> — which is the one genuinely current lecture in `docs/01`–`docs/13` and worth reading first.

Kubernetes deliberately owns none of the three: it defines an interface and lets a plugin implement it.

| Interface | Consumed by | Implemented by | Where it lives on a node |
| --- | --- | --- | --- |
| **CRI** — Container Runtime Interface | kubelet | containerd, CRI-O | a gRPC socket, e.g. `/run/containerd/containerd.sock` |
| **CNI** — Container Network Interface | kubelet (via the runtime) | Calico, Flannel, Cilium, Weave | binaries in `/opt/cni/bin`, config in `/etc/cni/net.d` |
| **CSI** — Container Storage Interface | kube-controller-manager + kubelet | ebs.csi.aws.com, `rancher.io/local-path`, … | a driver DaemonSet + a controller Deployment |

## CRI

**dockershim was removed in Kubernetes 1.24.** Docker Engine is no longer a supported runtime without a
shim; exam nodes run **containerd**. `docker ps` will not show you Kubernetes containers.

The kubelet's flag is `--container-runtime-endpoint`, usually set in
`/var/lib/kubelet/kubelet-flags.env` or the kubeadm-managed
`/var/lib/kubelet/config.yaml` / systemd drop-in.

```bash
# which runtime and version is each node using?
kubectl get nodes -o wide          # CONTAINER-RUNTIME column: containerd://1.7.x

# crictl is the CRI-level debugging tool — this is what you use when kubectl is down
sudo crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock
sudo crictl ps                     # running containers
sudo crictl ps -a                  # including exited — how you find a crash-looped controlplane pod
sudo crictl pods                   # sandboxes
sudo crictl images
sudo crictl logs <container-id>
sudo crictl inspect <container-id>
```

Three CLIs, three layers — a common exam-day confusion:

| Tool | Talks to | Use it for |
| --- | --- | --- |
| `crictl` | the **CRI** (kubelet's view) | debugging Kubernetes containers, especially static controlplane pods when the apiserver is down |
| `ctr` | containerd directly, namespaced (`-n k8s.io`) | low-level containerd operations |
| `nerdctl` | containerd, Docker-compatible UX | running ad-hoc containers on a containerd host |

When `kubectl get pods -n kube-system` cannot answer because the API server itself is down,
`sudo crictl ps -a | grep apiserver` followed by `sudo crictl logs <id>` is the recovery path.

## CNI

A CNI plugin gives every pod an IP and makes the flat pod network work. Kubernetes ships **no** default
plugin — a fresh kubeadm cluster sits with all nodes `NotReady` and CoreDNS `Pending` until one is
installed.

```bash
ls /etc/cni/net.d/                  # config files; lowest filename sorts first and wins
ls /opt/cni/bin/                    # the plugin binaries
kubectl get pods -n kube-system     # calico-node / kube-flannel-ds / cilium DaemonSet
```

The three rules a CNI implementation must satisfy:

1. every pod gets its own IP,
2. pods can reach every other pod without NAT,
3. nodes can reach every pod without NAT.

Symptoms that point at CNI: nodes `NotReady` with
`container runtime network not ready: NetworkReady=false … cni plugin not initialized`; pods stuck
`ContainerCreating` with `failed to set up sandbox`; CoreDNS `Pending`.

**NetworkPolicy is enforced by the CNI plugin, not by Kubernetes.** Flannel does not implement it —
policies apply silently and block nothing. Calico and Cilium do.

## CSI

CSI replaced the old in-tree cloud volume plugins, all of which have been removed. A driver has two
halves: a **controller** Deployment (provision/attach/snapshot) and a **node** DaemonSet
(mount/unmount).

```bash
kubectl get csidrivers
kubectl get csinodes
kubectl get storageclass                 # the PROVISIONER column is the CSI driver name
kubectl get volumeattachments
```

The link from a `StorageClass` to a driver is `provisioner:` — see
[08-Dynamic-Volume-Provisioning](08-Dynamic-Volume-Provisioning.md).

The RPCs worth knowing by name: `CreateVolume` / `DeleteVolume` (controller),
`ControllerPublishVolume` (attach), `NodeStageVolume` / `NodePublishVolume` (mount).

## What is *not* worth studying

The Docker-specific pre-requisite lectures — `docs/05-Application-Lifecycle-Management/04-Commands-and-Arguments-in-Docker.md`,
`docs/08-Storage/02`–`04`, `docs/09-Networking/06-Pre-requisite-Docker-Networking.md` — are useful
background on where these interfaces came from, but the Docker CLI is not present on an exam node and
none of it is directly testable.

#### K8s Reference Docs
- https://kubernetes.io/docs/concepts/architecture/cri/
- https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/
- https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/
- https://kubernetes.io/docs/concepts/storage/volumes/#csi
