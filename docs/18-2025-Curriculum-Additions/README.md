# 2025 CKA Curriculum Additions

The CKA exam was revised in **early 2025**. The five domains and their weightings did not change:

| Domain | Weight |
| --- | --- |
| Storage | 10% |
| Troubleshooting | 30% |
| Workloads & Scheduling | 15% |
| Cluster Architecture, Installation & Configuration | 25% |
| Services & Networking | 20% |

What changed is the **competency list underneath them**. Several topics are now named explicitly that
the KodeKloud lecture notes in `docs/01`–`docs/13` predate and therefore do not cover at all.

This folder is **not** part of the upstream KodeKloud course. It is fork-local material written to fill
those gaps so that anything generating study questions from this repo has source text for them.

| Note | Domain it sits under | Why it is here |
| --- | --- | --- |
| [01-Helm](01-Helm.md) | Cluster Architecture | "Use Helm and Kustomize to install cluster components" — new competency, zero upstream coverage |
| [02-Kustomize](02-Kustomize.md) | Cluster Architecture | same competency; `kubectl apply -k` is built in and fair game |
| [03-CRDs-and-Operators](03-CRDs-and-Operators.md) | Cluster Architecture | "Understand extension interfaces… CRDs, install and configure operators" |
| [04-Gateway-API](04-Gateway-API.md) | Services & Networking | "Use the Gateway API to manage Ingress traffic" — sits alongside classic Ingress, does not replace it |
| [05-Pod-Security-Standards](05-Pod-Security-Standards.md) | Cluster Architecture / Workloads | PodSecurityPolicy was **removed in 1.25**; PSS is what replaced it |
| [06-Horizontal-Pod-Autoscaling](06-Horizontal-Pod-Autoscaling.md) | Workloads & Scheduling | "Understand application scaling"; upstream notes stop at requests/limits |
| [07-Extension-Interfaces-CNI-CSI-CRI](07-Extension-Interfaces-CNI-CSI-CRI.md) | Cluster Architecture | named competency; upstream covers CNI well, CSI thinly, CRI only in passing |
| [08-Dynamic-Volume-Provisioning](08-Dynamic-Volume-Provisioning.md) | Storage | the storage domain now leans on dynamic provisioning, reclaim policies and binding modes |

## Two things worth internalising before any of the above

1. **The exam is `kubectl explain` and the docs, not memory.** Every note here ends with the
   kubernetes.io URL you are allowed to open during the exam. Practise navigating to it.
2. **Exam nodes run containerd.** Anything Docker-CLI-shaped in `docs/05` and the networking
   pre-requisites is background theory only — see [07-Extension-Interfaces-CNI-CSI-CRI](07-Extension-Interfaces-CNI-CSI-CRI.md).

#### Reference
- https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/
- https://github.com/cncf/curriculum
