# Pod Security Standards and Pod Security Admission

> Fork-local note. Not part of the upstream KodeKloud course.
> The Security section covers `securityContext` but predates PSS.
> Companion to [docs/07-Security/25-Security-Context.md](../07-Security/25-Security-Context.md).

**PodSecurityPolicy was removed in Kubernetes 1.25.** What replaced it is two separate things:

- **Pod Security Standards (PSS)** — three named policy *levels* defined by the project.
- **Pod Security Admission (PSA)** — the built-in admission controller that enforces a level, selected
  per namespace by **labels**. No CRD, no extra install.

## The three levels

| Level | Intent | Blocks |
| --- | --- | --- |
| `privileged` | unrestricted | nothing — this is the default when no label is set |
| `baseline` | prevent known privilege escalation | `privileged: true`, host namespaces (`hostNetwork`, `hostPID`, `hostIPC`), `hostPath` volumes, host ports, adding capabilities beyond `NET_BIND_SERVICE`, most `procMount`/sysctl/SELinux changes |
| `restricted` | hardened, current best practice | everything in baseline **plus** requires `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, `capabilities.drop: ["ALL"]`, `seccompProfile.type: RuntimeDefault`, and restricts volume types |

## The three modes

Each level can be applied in three modes, independently:

| Mode | Effect |
| --- | --- |
| `enforce` | violating pods are **rejected** |
| `audit` | allowed, but an annotation is written to the audit log |
| `warn` | allowed, but `kubectl` prints a warning to the user |

## Applying it — namespace labels

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prod
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: v1.31   # pin so an upgrade cannot tighten silently
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

```bash
kubectl label namespace prod pod-security.kubernetes.io/enforce=baseline
kubectl label namespace prod pod-security.kubernetes.io/warn=restricted

# dry-run the change against workloads that already exist — nothing is applied,
# but you get a warning per pod that WOULD be rejected
kubectl label --dry-run=server --overwrite namespace prod \
  pod-security.kubernetes.io/enforce=restricted
```

That `--dry-run=server` label trick is the single most useful command here: it tells you what a
tightening would break before you break it.

## A pod that satisfies `restricted`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hardened
  namespace: prod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: app
      image: nginxinc/nginx-unprivileged:stable
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop: ["ALL"]
        readOnlyRootFilesystem: true       # good practice, not required by restricted
```

`restricted` will not accept a stock `nginx` image, because it binds port 80 as root. That surprise is
worth remembering.

## Behaviour worth knowing

- **`enforce` applies at pod creation only.** Labelling a namespace does **not** evict pods that are
  already running, and it does not retroactively reject them.
- A **Deployment** whose pod template violates `enforce` is created happily — the *ReplicaSet* then
  fails to create pods. The error is on the ReplicaSet, not the Deployment:
  `kubectl describe rs <name>` / `kubectl get events`.
- Pods with `securityContext` set at **pod level** and **container level**: the container level wins for
  that container.
- PSA does not cover everything PSP did (no mutation, no per-user rules). For finer policy, clusters use
  a webhook such as Kyverno or OPA Gatekeeper — out of CKA scope but worth knowing the names.
- Cluster-wide defaults can be set in the API server's `AdmissionConfiguration` file, with namespace
  labels overriding them.

## Troubleshooting

```bash
kubectl get ns --show-labels | grep pod-security
kubectl describe rs <replicaset>            # "violates PodSecurity \"restricted:v1.31\": …"
kubectl get events -n prod --sort-by=.lastTimestamp
```

The rejection message names the exact level, version, and each field at fault — read it literally, it
tells you what to add to `securityContext`.

#### K8s Reference Docs
- https://kubernetes.io/docs/concepts/security/pod-security-standards/
- https://kubernetes.io/docs/concepts/security/pod-security-admission/
- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
