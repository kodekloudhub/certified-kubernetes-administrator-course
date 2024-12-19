# Managed Clusters

Knowledge of managed clusters and how to build them is *not* part of the CKA course curriculum and therefore you will not be tested on it. These labs are provided just for fun and because people ask how to create them in KodeKloud playgrounds.

Managed clusters are where part of the cluster is managed by a major cloud provider. The control plane is *always* managed in this type of cluster, meaning that you do not have to configure control plane nodes, high availability or manage etcd - all this is "managed" for you for a fixed cost per hour the cluster is in existence.

Depending on the options chosen when creating, the worker nodes may be unmanaged, part or fully managed. However in the KodeKloud playgrounds only unmanaged nodes are available so that is what we will be creating.

We have some instructions for building managed clusters in KodeKloud playgrounds below. **NOTE** If you are deploying a cluster as part of a lab exercise in one of the other courses, then wherever this guide tells you to run commands in a CloudShell terminal you must instead run those commands in the lab's terminal.

* AWS EKS
    * [Manual build using the console](./eks/console/README.md)
    * [Automated build using Terraform](https://github.com/kodekloudhub/amazon-elastic-kubernetes-service-course/blob/main/docs/playground.md)
* Azure AKS
    * [Manual build using the console](./aks/console/README.md)
* Google GKE
    * [Manual build using the console](./gke/console/README.md)

