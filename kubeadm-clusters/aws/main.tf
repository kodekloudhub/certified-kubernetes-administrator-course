###############################################################
#
# This file contains the provide decalarations and outputs
#
###############################################################

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "tf:stackid" = "kubeadm-cluster"
    }
  }
}

output "connect_controlplane" {
  value = "ssh ubuntu@${aws_instance.kubenode["controlplane"].public_ip}"
}

output "connect_node01" {
  value = "ssh ubuntu@${aws_instance.kubenode["node01"].public_ip}"
}

output "connect_node02" {
  value = "ssh ubuntu@${aws_instance.kubenode["node02"].public_ip}"
}

output "etc-hosts" {
  value = "\n${aws_instance.kubenode["controlplane"].public_ip} controlplane\n${aws_instance.kubenode["node01"].public_ip} node01\n${aws_instance.kubenode["node02"].public_ip} node02\n"
}