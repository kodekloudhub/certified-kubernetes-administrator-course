# Region to build in
variable "aws_region" {
  type    = string
  default = "us-east-1"
}


# Names of the EC2 instances to create
locals {
  instances = [
    "controlplane",
    "node01",
    "node02"
  ]
}

