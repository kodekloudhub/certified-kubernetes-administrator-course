####################################################################
#
#
#
####################################################################

terraform {
  required_providers {
    localos = {
      source  = "fireflycons/localos"
      version = "0.1.2"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "kubernetes.io/cluster/demo-eks" = "owned"
    }
  }
}

output "NodeInstanceRole" {
  value = aws_iam_role.node_instance_role.arn
}

output "NodeSecurityGroup" {
  value = aws_security_group.node_security_group.id
}

output "NodeAutoScalingGroup" {
  value = aws_cloudformation_stack.autoscaling_group.outputs["NodeAutoScalingGroup"]
}