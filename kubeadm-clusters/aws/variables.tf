variable "my_ip" {
  description = "Your broadband public IP"
  type = string
  default = ""
}

# Names of the EC2 instances to create
locals {
  instances = [
    "controlplane",
    "node01",
    "node02"
  ]
}

