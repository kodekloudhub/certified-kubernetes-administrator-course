# Helm

> Fork-local note. Not part of the upstream KodeKloud course.
> Covers the CKA competency *"Use Helm and Kustomize to install cluster components."*

Helm is a **package manager** for Kubernetes. A **chart** is a directory of templated manifests plus a
`values.yaml`; installing a chart renders those templates and applies the result as a **release**.

## Chart anatomy

```
mychart/
├── Chart.yaml          # name, version, appVersion, dependencies
├── values.yaml         # default values — this is what you override
├── charts/             # vendored sub-charts (dependencies)
└── templates/
    ├── deployment.yaml # Go templates: {{ .Values.replicaCount }}
    ├── service.yaml
    ├── _helpers.tpl    # named template definitions
    └── NOTES.txt       # printed after install
```

Three scopes you will see inside templates: `.Values` (from values.yaml / `--set`), `.Release`
(`.Release.Name`, `.Release.Namespace`), and `.Chart` (`.Chart.Name`, `.Chart.Version`).

## The commands that matter

```bash
# repositories
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm repo list
helm search repo ingress-nginx           # search added repos
helm search hub  ingress-nginx           # search Artifact Hub

# inspect BEFORE installing
helm show chart  ingress-nginx/ingress-nginx
helm show values ingress-nginx/ingress-nginx        # the full list of overridable values
helm template myrel ingress-nginx/ingress-nginx     # render locally, apply nothing

# install
helm install myrel ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.type=NodePort \
  --version 4.11.2

helm install myrel ingress-nginx/ingress-nginx -f my-values.yaml
helm install myrel ./mychart                        # from a local directory
helm install myrel ./mychart --dry-run --debug      # validate without applying

# lifecycle
helm list -A                             # -A = all namespaces
helm status myrel -n ingress-nginx
helm get values myrel                    # what overrides are in effect
helm get manifest myrel                  # what is actually applied
helm upgrade myrel ingress-nginx/ingress-nginx --reuse-values --set controller.replicaCount=2
helm upgrade --install myrel ./mychart   # idempotent install-or-upgrade
helm history  myrel
helm rollback myrel 1
helm uninstall myrel -n ingress-nginx
```

## Points that catch people out

- **`helm install` needs a release name and a chart**, in that order:
  `helm install <release> <chart>`. `--generate-name` skips the first.
- **`--set` beats `-f`**, and later `-f` files beat earlier ones. Nested keys use dots
  (`--set controller.service.type=NodePort`); list items use brackets
  (`--set 'controller.tolerations[0].key=node-role'`); commas inside a value need escaping
  (`--set 'a=x\,y'`).
- **`helm upgrade` without `--reuse-values` resets to chart defaults** plus whatever you pass this
  time. Forgetting this silently reverts earlier overrides.
- **Release state lives in a Secret** in the release namespace
  (`kubectl get secret -l owner=helm`), not in a Helm server component. Helm 3 has no Tiller.
- **`helm template` is the offline escape hatch**: render to stdout, pipe to `kubectl apply -f -` if
  you want the objects without Helm managing them.
- Namespaces: `helm install -n foo` does **not** create the namespace unless you add
  `--create-namespace`.

## Troubleshooting a release

```bash
helm status myrel -n ns                      # deployed / failed / pending-upgrade
helm get manifest myrel -n ns | kubectl diff -f -
helm history myrel -n ns                     # then: helm rollback myrel <revision>
```

If an upgrade is stuck in `pending-upgrade`, the previous operation was interrupted — `helm rollback`
to the last good revision.

#### K8s / Helm Reference Docs
- https://helm.sh/docs/intro/using_helm/
- https://helm.sh/docs/helm/helm_install/
- https://helm.sh/docs/chart_template_guide/
