###############################################################
#
# This file contains configuration for all security groups
# we will need.
#
###############################################################

# Security group for egress to anywhere.
# Will be applied to all EC2 instances
resource "aws_security_group" "egress_all" {
  name   = "egress_all"
  vpc_id = data.aws_vpc.default_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_vpc" {
  name   = "ingress_vpc"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
  }
}

# Security group for ingress to controlplane
resource "aws_security_group" "controlplane" {
  name   = "controlplane"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    # Allow API server access from anywhere inside the VPC
    # and from the cloudshell node
    description = "API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_vpc.default_vpc.cidr_block
    ]
  }

  ingress {
    # Allow etcd access from anywhere inside the VPC
    description = "etcd"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_vpc.default_vpc.cidr_block
    ]
  }
}

resource "aws_vpc_security_group_ingress_rule" "cloudshell_to_api_server" {
  description       = "Allow API server access from cloudshell"
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
  cidr_ipv4         = "${chomp(data.http.cloudshell_ip.response_body)}/32"
  security_group_id = aws_security_group.controlplane.id
}

resource "aws_vpc_security_group_ingress_rule" "cloudshell_to_controlplane_SSH" {
  description       = "Allow SSH access from cloudshell"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "${chomp(data.http.cloudshell_ip.response_body)}/32"
  security_group_id = aws_security_group.controlplane.id
}


# Security group for ingress to worker nodes
resource "aws_security_group" "workernode" {
  name   = "workernode"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    # Allow kubelet access from any host that has controlplane security group
    description = "kubelet api"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    security_groups = [
      aws_security_group.controlplane.id
    ]
  }
}

resource "aws_vpc_security_group_ingress_rule" "cloudshell_to_workernodes_SSH" {
  description       = "Allow SSH access from cloudshell"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "${chomp(data.http.cloudshell_ip.response_body)}/32"
  security_group_id = aws_security_group.workernode.id
}

resource "aws_vpc_security_group_ingress_rule" "cloudshell_to_workernodes_nodeport" {
  description       = "Allow NodePort access from cloudshell"
  from_port         = 32000
  to_port           = 32767
  ip_protocol       = "tcp"
  cidr_ipv4         = "${chomp(data.http.cloudshell_ip.response_body)}/32"
  security_group_id = aws_security_group.workernode.id
}

resource "aws_vpc_security_group_ingress_rule" "browser_to_workernodes_nodeport" {
  count = length(var.my_ip) > 0 ? 1 : 0
  description       = "Allow NodePort access from user's browser"
  from_port         = 32000
  to_port           = 32767
  ip_protocol       = "tcp"
  cidr_ipv4         = "${var.my_ip}/32"
  security_group_id = aws_security_group.workernode.id
}

# Security group for communication between weave pods
resource "aws_security_group" "weave" {
  name   = "weave"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "Weave TCP"
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    security_groups = [
      aws_security_group.controlplane.id,
      aws_security_group.workernode.id
    ]
  }

  ingress {
    description = "Weave UDP"
    from_port   = 6783
    to_port     = 6784
    protocol    = "udp"
    security_groups = [
      aws_security_group.controlplane.id,
      aws_security_group.workernode.id
    ]
  }
}

