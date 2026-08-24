# Kustomize

> Fork-local note. Not part of the upstream KodeKloud course.
> Covers the CKA competency *"Use Helm and Kustomize to install cluster components."*

Kustomize does **template-free** customisation: you keep plain YAML and describe transformations in a
`kustomization.yaml`. It is **built into kubectl** — no binary to install, which is why it is fair game
on an exam node.

```bash
kubectl kustomize ./overlays/prod        # render to stdout, apply nothing
kubectl apply -k ./overlays/prod         # render and apply
kubectl delete -k ./overlays/prod
kubectl diff -k ./overlays/prod          # what would change
```

The standalone `kustomize` binary is newer than the version vendored into kubectl. If a field is
rejected, that mismatch is usually why.

## Layout: base + overlays

```
app/
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── overlays/
    ├── dev/
    │   └── kustomization.yaml
    └── prod/
        ├── kustomization.yaml
        └── replica-patch.yaml
```

```yaml
# base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

```yaml
# overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: prod
namePrefix: prod-
nameSuffix: -v2

labels:
  - pairs:
      env: prod
    includeSelectors: false     # true rewrites selectors too — usually NOT what you want against an
                                # existing Deployment, whose selector is immutable

resources:
  - ../../base

images:
  - name: nginx                 # matches the image name used in the base
    newName: registry.example.com/nginx
    newTag: "1.27"

replicas:
  - name: my-deployment
    count: 5

patches:
  - path: replica-patch.yaml    # strategic-merge patch
  - target:                     # JSON 6902 patch, targeted by kind + name
      kind: Deployment
      name: my-deployment
    patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/imagePullPolicy
        value: Always

configMapGenerator:
  - name: app-config
    literals:
      - LOG_LEVEL=debug
    files:
      - app.properties
secretGenerator:
  - name: app-secret
    literals:
      - password=s3cret

generatorOptions:
  disableNameSuffixHash: true   # by default generators append a content hash to the name
```

## Things to know

- **`bases:` is deprecated.** Another kustomization directory goes under `resources:` now. Older
  tutorials still show `bases:`, `commonLabels:`, `patchesStrategicMerge:` and `patchesJson6902:` —
  those are legacy spellings of `resources:`, `labels:` and `patches:`.
- **ConfigMap/Secret generators append a content hash** (`app-config-7fc2h4d5k9`) so that changing the
  data rolls the pods mounting it. Kustomize rewrites every reference to the hashed name for you.
  `disableNameSuffixHash: true` turns that off.
- **A strategic-merge patch only needs enough of the object to identify it** — apiVersion, kind, name,
  and the fields being changed:

  ```yaml
  # replica-patch.yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: my-deployment
  spec:
    replicas: 5
  ```

- **Lists merge by key, not by position.** Containers merge on `name`, ports on `containerPort`.
  Removing a list element needs a JSON 6902 `op: remove`, or the `$patch: delete` directive.
- **`kubectl apply -k` does not prune.** Deleting a resource from `resources:` leaves the live object
  behind; remove it explicitly.
- `namespace:` in a kustomization rewrites the namespace of every rendered object, including
  RoleBinding subjects.

## Helm or Kustomize?

| | Helm | Kustomize |
| --- | --- | --- |
| Mechanism | Go templating + values | overlay/patch plain YAML |
| Install | separate binary | built into `kubectl` |
| Third-party software | the normal way | awkward |
| Small per-environment deltas on your own manifests | heavy | the normal way |
| Release history / rollback | yes | no — that is what git is for |

They compose: `helm template` a chart, then patch the rendered output with Kustomize.

#### K8s Reference Docs
- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/
