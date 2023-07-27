variable "access_key" {
  type        = string
  description = "Access key for AWS environment"
}

variable "secret_key" {
  type        = string
  description = "Secret key for AWS environment"
}

# Names of the EC2 instances to create
locals {
  instances = [
    "controlplane",
    "node01",
    "node02"
  ]
}

