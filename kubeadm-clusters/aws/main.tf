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
  access_key = var.access_key
  secret_key = var.secret_key
}

output "connect_command" {
  value       = "ssh -i ${pathexpand("~/.ssh/kubeadm-aws.pem")} ubuntu@${aws_instance.student_node.public_ip}"
  description = "Public IP of student_node. Connect to this address from your SSH client."
}

output "node01" {
  value = aws_instance.kubenode["node01"].public_ip
}

output "node02" {
  value = aws_instance.kubenode["node02"].public_ip
}
