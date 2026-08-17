# Commit: fix: explicitly install and pin cri-tools (crictl) — Kubernetes v1.31

## Short summary
fix: explicitly install and pin `cri-tools` (crictl) — Kubernetes v1.31

## Full commit message
fix: explicitly install and pin `cri-tools` (crictl) — Kubernetes v1.31

From Kubernetes v1.31 the `crictl` binary is provided by the `cri-tools` package. Install and pin `cri-tools` alongside the Kubernetes toolchain so `crictl` is available immediately after installing `kubeadm`.

Changes:
- Add `cri-tools` to `apt-get install` and `apt-mark hold` lines
- Update docs referencing Kubernetes version to `v1.31.0` where applicable

Files touched (mention in the commit body):
- `kubeadm-clusters/apple-silicon/scripts/03-setup-nodes.sh`
- `kubeadm-clusters/apple-silicon/scripts/04-kube-components.sh`
- `kubeadm-clusters/generic/04-node-setup.md`
- `kubeadm-clusters/virtualbox/ubuntu/vagrant/node-setup.sh`
- `kubeadm-clusters/aws/terraform/controlplane.sh`
- `kubeadm-clusters/aws-ha/terraform/controlplane.sh`
- `kubeadm-clusters/aws-ha/docs/05-node-setup.md`
- `docs/11-Install-Kubernetes-the-kubeadm-way/04-Demo-Deployment-with-Kubeadm.md`

## How to use
Run one of these commands when your changes are staged:

```bash
git commit -m "fix: explicitly install and pin cri-tools (crictl) — Kubernetes v1.31" -m "From Kubernetes v1.31 the `crictl` binary is provided by the `cri-tools` package. Install and pin `cri-tools` alongside the Kubernetes toolchain so `crictl` is available immediately after installing kubeadm.\n\nChanges:\n- Add `cri-tools` to `apt-get install` and `apt-mark hold` lines\n- Update docs referencing Kubernetes version to `v1.31.0` where applicable\n\nFiles touched: <list files here>"
```

Or open the commit editor and paste the full message above.
