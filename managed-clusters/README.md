# Managed Clusters

Knowledge of managed clusters and how to build them is *not* part of the CKA course curriculum and therefore you will not be tested on it. These labs are provided just for fun and because people ask how to create them in KodeKloud playgrounds.

Managed clusters are where part of the cluster is managed by a major cloud provider. The control plane is *always* managed in this type of cluster, meaning that you do not have to configure control plane nodes, high availability or manage etcd - all this is "managed" for you for a fixed cost per hour the cluster is in existence.

Depending on the offering, the worker nodes may be unmanaged, part or fully managed.

We have some instructions for building managed clusters in KodeKloud playgrounds here:

* [AWS EKS](./eks/) - Automated build using Terraform.
* [AWS EKS](https://kodekloud.com/community/t/playground-series-how-to-create-an-eks-cluster-in-kodekloud-playground/330748) - Manual build using the console.
* [Azure AKS](./aks/console/README.md) - Manual build using the console
* [Google GKE](https://kodekloud.com/community/t/playground-series-how-to-create-a-managed-kubernetes-cluster-with-google-kubernetes-engine/230314) - Manual build using the console.

