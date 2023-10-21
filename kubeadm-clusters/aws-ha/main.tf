###############################################################
#
# This file contains the provide decalarations and outputs
#
###############################################################

terraform {
  required_providers {
    localos = {
      source  = "fireflycons/localos"
      version = "0.1.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "tf:stackid" = "kubeadm-cluster"
    }
  }
}

output "connect_student_node" {
  description = "SSH command for student-node"
  value       = "ssh ubuntu@${aws_instance.student_node.public_ip}"
}

output "address_student_node" {
  description = "Public IP of student-node"
  value       = aws_instance.student_node.public_ip
}

# We can use either of these IPs to connect to node ports
output "address_node01" {
  description = "Public IP of node01"
  value       = aws_instance.kubenode["node01"].public_ip
}

output "address_node02" {
  description = "Public IP of node02"
  value       = aws_instance.kubenode["node02"].public_ip
}

