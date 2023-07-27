###############################################################
#
# This file contains configuration for all data source queries
#
###############################################################

# Get the default VPC details
data "aws_vpc" "default_vpc" {
  default = true
}

# Get the AMI for Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Get Public IP of your broadband account. This allows us to lock down SSH access
# into the environment from anyone other than yourself, by inserting your public
# IP to a security group ingress rule.
# Try this URL in your browser!
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

# Get the subnets to use for network interface creation. We will place one node on each subnet.
# Each subnet is in a different AZ which in practice is good for fault tolerance.
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  filter {
    name = "availability-zone"
    values = [
      "${var.aws_region}a",
      "${var.aws_region}b",
      "${var.aws_region}c"
    ]
  }
}
