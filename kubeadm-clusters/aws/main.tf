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


output "address_controlplane" {
  description = "Public IP of controlplane"
  value = aws_instance.kubenode["controlplane"].public_ip
}

output "address_node01" {
  description = "Public IP of node01"
  value = aws_instance.kubenode["node01"].public_ip
}

output "address_node02" {
  description = "Public IP of node02"
  value = aws_instance.kubenode["node02"].public_ip
}

output "connect_controlplane" {
  description = "SSH command for controlplane"
  value = "ssh ubuntu@controlplane"
}

output "connect_node01" {
  description = "SSH command for node01"
  value = "ssh ubuntu@$node01"
}

output "connect_node02" {
  description = "SSH command for node02"
  value = "ssh ubuntu@node02"
}

output "etc-hosts" {
  description = "Additional lines for /etc/hosts"
  value = "\n${aws_instance.kubenode["controlplane"].public_ip} controlplane\n${aws_instance.kubenode["node01"].public_ip} node01\n${aws_instance.kubenode["node02"].public_ip} node02\n"
}