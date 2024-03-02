###############################################################
#
# This file contains configuration for all EC2 resources
# ENI, EC2 instance, key-pair, ENI->Security group associations
# and key pair for logging in.
#
###############################################################

# Create an SSH key pair for logging into the EC2 instances
# Security note:
# Generally not good practice to generate keys like this in Terraform
# as the key material is stored in the state file.
# Key pairs should be created externally and passed to Terraform as
# a variable.
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to local .ssh directory so it can be used by SSH clients
resource "local_sensitive_file" "pem_file" {
  filename        = pathexpand("~/.ssh/id_rsa")
  file_permission = "600"
  content         = tls_private_key.key_pair.private_key_pem
}

# Upload the public key of the key pair to AWS so it can be added to the instances
resource "aws_key_pair" "kube_kp" {
  key_name   = "kube_kp"
  public_key = trimspace(tls_private_key.key_pair.public_key_openssh)
}

# Create 3 network interfaces (ENIs) which will be for the 3 cluster nodes
# We need to create these spearately from the instances themselves to prevent
# a circular dependency when setting up host files in the EC2 instances - we
# need to know the IP addresses the nodes will have before they are actually
# created.
resource "aws_network_interface" "kubenode" {
  for_each        = { for idx, inst in local.instances : inst => idx }
  subnet_id       = data.aws_subnets.public.ids[each.value]
  security_groups = [aws_security_group.egress_all.id]
  tags = {
    Name = local.instances[each.value]
  }
}

# Create the kube node instances
# The user_data will set the hostname and entries for
# all nodes in /etc/hosts
resource "aws_instance" "kubenode" {
  for_each      = toset(local.instances)
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = aws_key_pair.kube_kp.key_name
  instance_type = "t3.medium"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.kubenode[each.value].id
  }
  tags = {
    "Name" = each.value
  }
  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname ${each.value}
              cat <<EOF >> /etc/hosts
              ${aws_network_interface.kubenode["controlplane"].private_ip} controlplane
              ${aws_network_interface.kubenode["node01"].private_ip} node01
              ${aws_network_interface.kubenode["node02"].private_ip} node02
              EOF
              echo "PRIMARY_IP=$(ip route | grep default | awk '{ print $9 }')" >> /etc/environment
              EOT
}

# Create the student_node
# The user_data will set the hostname and entries for
# all nodes in /etc/hosts
resource "aws_instance" "student_node" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t3.small"
  key_name      = aws_key_pair.kube_kp.key_name
  vpc_security_group_ids = [
    aws_security_group.student_node.id,
    aws_security_group.egress_all.id
  ]
  tags = {
    "Name" = "student_node"
  }
  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname "student-node"
              echo "${tls_private_key.key_pair.private_key_pem}" > /home/ubuntu/.ssh/id_rsa
              chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
              chmod 600 /home/ubuntu/.ssh/id_rsa
              curl -sS https://starship.rs/install.sh | sh -s -- -y
              echo 'eval "$(starship init bash)"' >> /home/ubuntu/.bashrc
              cat <<EOF >> /etc/hosts
              ${aws_network_interface.kubenode["controlplane"].private_ip} controlplane
              ${aws_network_interface.kubenode["node01"].private_ip} node01
              ${aws_network_interface.kubenode["node02"].private_ip} node02
              EOF
              EOT
}

# Attach controlplane security group to controlplane ENI
resource "aws_network_interface_sg_attachment" "controlplane_sg_attachment" {
  security_group_id    = aws_security_group.controlplane.id
  network_interface_id = aws_instance.kubenode["controlplane"].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "controlplane_sg_attachment_weave" {
  security_group_id    = aws_security_group.weave.id
  network_interface_id = aws_instance.kubenode["controlplane"].primary_network_interface_id
}

# Attach workernodes security group to node01 ENI
resource "aws_network_interface_sg_attachment" "node01_sg_attachment" {
  security_group_id    = aws_security_group.workernode.id
  network_interface_id = aws_instance.kubenode["node01"].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "node01_sg_attachment_weave" {
  security_group_id    = aws_security_group.weave.id
  network_interface_id = aws_instance.kubenode["node01"].primary_network_interface_id
}

# Attach workernodes security group to node02 ENI
resource "aws_network_interface_sg_attachment" "node02_sg_attachment" {
  security_group_id    = aws_security_group.workernode.id
  network_interface_id = aws_instance.kubenode["node02"].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "node02_sg_attachment_weave" {
  security_group_id    = aws_security_group.weave.id
  network_interface_id = aws_instance.kubenode["node02"].primary_network_interface_id
}

