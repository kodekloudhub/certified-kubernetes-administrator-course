# Kubeadm HA on AWS EC2

Updated March 2024

This guide shows how to install a 5 node highly-available kubeadm cluster on AWS EC2 instances. If using the KodeKloud AWS Playground environment, please ensure you have selected region `us-east-1` (N. Virginia) from the region selection at the top right of the AWS console. To maintain compatibility with the playground permissions, we will use the following EC2 instance configuration.

* Instance type: `t3.medium`
* Operating System: Ubuntu 22.04 (at time of writing)
* Storage: `gp2`, 8GB

Note that this is an exercise in simply getting a cluster running and is a learning exercise only! It will not be suitable for serving workloads to the internet, nor will it be properly secured, otherwise this guide would be three times longer! It should not be used as a basis for building a production cluster.

[Get Started](./docs/01-prerequisites.md)
