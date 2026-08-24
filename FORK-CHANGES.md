# Fork changes

This is a fork of [kodekloudhub/certified-kubernetes-administrator-course](https://github.com/kodekloudhub/certified-kubernetes-administrator-course).
Everything on this page is **fork-local** — none of it is upstream.

The upstream lecture notes in `docs/01`–`docs/13` are largely frozen around Kubernetes **1.18–1.25**.
Sections 14–16 (Lightning Labs, Mock Exams, Ultimate Mocks) and `kubeadm-clusters/` are much more
current and were left alone. The changes below fix material in `docs/01`–`docs/13` that is now either
**factually wrong** or **will fail against a modern cluster**, and add coverage for topics the **2025
CKA curriculum revision** made explicitly testable.

Every in-place correction is marked in the file itself with a `> **Fork correction:**` blockquote (or a
`# Fork correction:` comment inside YAML) explaining what was wrong and why, so the original claim and
its replacement stay visible side by side rather than the fix looking like it was always there.

---

## 1. Corrections — factual errors

| File | Was | Now |
| --- | --- | --- |
| [docs/03-Scheduling/12-Resource-Limits.md](docs/03-Scheduling/12-Resource-Limits.md) | "By default K8s assumes 0.5 CPU / 256Mi request and 1 CPU / 512Mi limit" | Kubernetes applies **no** default requests or limits. Defaults come only from a `LimitRange`. Added `LimitRange`, `ResourceQuota` and QoS-class sections, and what actually happens on CPU vs memory overrun. |
| [docs/06-Cluster-Maintenance/07-Backup-and-Restore-Methods.md](docs/06-Cluster-Maintenance/07-Backup-and-Restore-Methods.md) | etcd cert named `etcd-server.crt` | The kubeadm path is `/etc/kubernetes/pki/etcd/server.crt` / `server.key`. (The practice tests already had this right; the lecture did not.) |

## 2. Corrections — removed APIs and dead infrastructure

These would fail outright on any cluster you would meet today.

| File | Problem | Fix |
| --- | --- | --- |
| [docs/09-Networking/22-Ingress.md](docs/09-Networking/22-Ingress.md) | `apiVersion: extensions/v1beta1` with `backend.serviceName` / `servicePort` — **removed in Kubernetes 1.22** | Rewritten to `networking.k8s.io/v1`: `pathType` on every path, `backend.service.name` / `.port.number`, `defaultBackend`, `ingressClassName`. Added an `IngressClass` section, a `pathType` table, and the imperative `kubectl create ingress` forms. |
| [docs/09-Networking/22-Ingress.md](docs/09-Networking/22-Ingress.md) | controller image `quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0` — dead registry path | `registry.k8s.io/ingress-nginx/controller` |
| [docs/09-Networking/23-Ingress-Annotations-and-rewrite-target.md](docs/09-Networking/23-Ingress-Annotations-and-rewrite-target.md) | same removed API | `networking.k8s.io/v1`, plus a capture-group / `use-regex` example and the `ssl-redirect` annotation |
| [docs/09-Networking/24-Practice-Test-CKA-Ingress-Net-1.md](docs/09-Networking/24-Practice-Test-CKA-Ingress-Net-1.md) | **two** solutions used the removed schema while others in the same file used the correct one — the file contradicted itself | both converted to `networking.k8s.io/v1` |
| [docs/09-Networking/25-Practice-Test-CKA-Ingress-Net-2.md](docs/09-Networking/25-Practice-Test-CKA-Ingress-Net-2.md) | YAML indentation bug: `name:` and `port:` level with `service:` instead of nested under it — the manifest would be rejected | indentation fixed |
| [docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md](docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md) | installs from `apt.kubernetes.io` / `kubernetes-xenial` with the `packages.cloud.google.com` key — **frozen Sept 2023, shut down early 2024** | `pkgs.k8s.io` community repos, with a note that they are versioned per minor release and there is no "latest" channel. (`05-...` in the same folder already used the correct repo — the two contradicted each other.) |
| [docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md](docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md) | `kubeadm.k8s.io/v1beta3`, pinned `kubernetesVersion: v1.25.4` | `v1beta4` (current from 1.31), with instructions to take the version from `kubeadm config print init-defaults` on the node rather than from a note |
| [docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md](docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md) | the *containerd* install block also added the dead Kubernetes apt repo | removed — containerd comes from the distro repo |
| [docs/04-Logging-and-Monitoring/02-Monitor-Cluster-Components.md](docs/04-Logging-and-Monitoring/02-Monitor-Cluster-Components.md) | clones `kubernetes-incubator/metrics-server`, applies `deploy/1.8+/` — neither exists | `kubernetes-sigs/metrics-server` `components.yaml`, plus the `--kubelet-insecure-tls` patch every kubeadm lab needs and how to verify the APIService |
| [docs/03-Scheduling/18-Multiple-Schedulers.md](docs/03-Scheduling/18-Multiple-Schedulers.md) | downloads a **v1.12.0** `kube-scheduler` binary; `--scheduler-name` flag | `KubeSchedulerConfiguration` (`kubescheduler.config.k8s.io/v1`) via `--config`, with a working static-pod manifest and a note on the RBAC needed to run it as a Deployment |
| [docs/07-Security/26-Practice-Test-Security-Context.md](docs/07-Security/26-Practice-Test-Security-Context.md) | `kubectl exec ubuntu-sleeper whoami` — the no-`--` form was **removed in 1.24** | `kubectl exec ubuntu-sleeper -- whoami` |

## 3. Corrections — noise, not breakage

| File | Change |
| --- | --- |
| [docs/06-Cluster-Maintenance/07-Backup-and-Restore-Methods.md](docs/06-Cluster-Maintenance/07-Backup-and-Restore-Methods.md) | `ETCDCTL_API=3` dropped from the commands — v3 has been the default since etcd 3.4. Noted rather than silently removed. |
| [docs/06-Cluster-Maintenance/07-Backup-and-Restore-Methods.md](docs/06-Cluster-Maintenance/07-Backup-and-Restore-Methods.md) | The restore procedure said `service kube-apiserver stop`, which only applies to a non-kubeadm cluster. Split into **kubeadm (static pods — move the manifests out of `/etc/kubernetes/manifests/`, restore to a new `--data-dir`, repoint the `hostPath` in `etcd.yaml`)** and the original systemd path. The kubeadm variant is the exam case. |

## 4. Additions — `docs/18-2025-Curriculum-Additions/`

The CKA was revised in early 2025. Domains and weightings are unchanged; the competency list beneath
them is not. These topics are now named explicitly and had **zero** coverage in this repo:

- [01-Helm](docs/18-2025-Curriculum-Additions/01-Helm.md)
- [02-Kustomize](docs/18-2025-Curriculum-Additions/02-Kustomize.md)
- [03-CRDs-and-Operators](docs/18-2025-Curriculum-Additions/03-CRDs-and-Operators.md)
- [04-Gateway-API](docs/18-2025-Curriculum-Additions/04-Gateway-API.md)
- [05-Pod-Security-Standards](docs/18-2025-Curriculum-Additions/05-Pod-Security-Standards.md) — PodSecurityPolicy was removed in 1.25
- [06-Horizontal-Pod-Autoscaling](docs/18-2025-Curriculum-Additions/06-Horizontal-Pod-Autoscaling.md)
- [07-Extension-Interfaces-CNI-CSI-CRI](docs/18-2025-Curriculum-Additions/07-Extension-Interfaces-CNI-CSI-CRI.md)
- [08-Dynamic-Volume-Provisioning](docs/18-2025-Curriculum-Additions/08-Dynamic-Volume-Provisioning.md) — reclaim policies, binding modes, expansion

Numbered **18** because `docs/17-tips-and-tricks/` already exists upstream.

---

## Reviewed and deliberately left alone

- **[docs/02-Core-Concepts/03-Docker-vs-ContainerD.md](docs/02-Core-Concepts/03-Docker-vs-ContainerD.md)** is genuinely current — dockershim removal in 1.24, and the `ctr` / `nerdctl` / `crictl` split. Exam nodes are containerd and troubleshooting goes through `crictl`, so this is one to internalise rather than skim.
- RBAC, NetworkPolicy, namespaces, the scheduling primitives (taints/tolerations, affinity, node selectors) and the imperative-command material are all still accurate.
- `docs/16-Ultimate-Mocks/` is the most current content in the repo, including the cluster-state-questions strategy note. Worth reading **early**, not saving for the end.
- The **Lightning Lab 1.28 → 1.29 upgrade** walkthrough is mechanically still correct — edit the apt source minor version, `kubeadm upgrade apply` on the controlplane, `kubeadm upgrade node` on the workers. Only the version numbers are dated.
- `docs/08-Storage/13-Practice-Test-Storage-Class.md` already handles `WaitForFirstConsumer` correctly; the extra depth went into the new section note rather than rewriting the lecture.

## Not exam material — background only

Conceptually fine, but they teach a Docker CLI that is **not present on an exam node**. Nothing here is
directly testable, and it is a poor source for generated practice questions:

- `docs/05-Application-Lifecycle-Management/04-Commands-and-Arguments-in-Docker.md`
- `docs/08-Storage/02-Introduction-to-Docker-Storage.md`, `03-Storage-in-Docker.md`, `04-Volume-Driver-Plugins-in-Docker.md`
- `docs/09-Networking/02-Pre-requisite-Switching-Routing-Gateways.md` … `07-Pre-requisite-CNI.md`

The one that *is* worth reading is `docs/02-Core-Concepts/03-Docker-vs-ContainerD.md`, and its modern
counterpart [07-Extension-Interfaces-CNI-CSI-CRI](docs/18-2025-Curriculum-Additions/07-Extension-Interfaces-CNI-CSI-CRI.md).

## Still open

- **Version numbers throughout `docs/01`–`docs/13` are dated** (1.18–1.25 era). Where a version is only
  illustrative it was left as-is rather than churning every file; where a version made a command *fail*,
  it was fixed and listed above.
- The upstream repo will keep moving. Because these corrections are in-place edits to upstream files,
  a future `git merge upstream/master` will conflict in the ten files listed above. The `Fork
  correction:` markers make it obvious which side of a conflict is the fork's.
