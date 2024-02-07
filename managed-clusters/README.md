# Managed Clusters

Managed clusters are where part of the cluster is managed by a major cloud provider. The control plane is *always* managed in this type of cluster, meaning that you do not have to configure control plane nodes, high availability or manage etcd - all this is "managed" for you for a fixed cost per hour the cluster is in existence.

Depending on the offering, the worker nodes may be unmanaged, part or fully managed.

We have some instructions for building managed clusters in KodeKloud playgrounds here:

* [AWS EKS](./eks/) - Using Terraform
* [AWS EKS](https://kodekloud.com/community/t/playground-series-how-to-create-an-eks-cluster-in-kodekloud-playground/330748) - Using the console
* [Azure AKS](https://kodekloud.com/community/t/playground-series-how-to-create-a-managed-kubernetes-cluster-on-azure-playground/224190) - Using the console
* [Google GKE](https://kodekloud.com/community/t/playground-series-how-to-create-a-managed-kubernetes-cluster-with-google-kubernetes-engine/230314) - Using the console

