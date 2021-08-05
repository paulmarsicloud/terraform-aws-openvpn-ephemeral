terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/arm64/hvm/ebs-gp2/ami-id"
}

data "aws_caller_identity" "current" {}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
}

resource "aws_security_group" "openvpn_sg" {
  name = "openvpn_sg"

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["${var.public_ip}/32"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "openvpn_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "openvpn_key_pair" {
  key_name   = "openvpn_key_pair_${var.region}"
  public_key = tls_private_key.openvpn_private_key.public_key_openssh
  provisioner "local-exec" {
    command = "cat ${var.output_suppression}; rm -rf ~/.ssh/openvpn_key_pair_${var.region}.pem; echo '${tls_private_key.openvpn_private_key.private_key_pem}' > ~/.ssh/openvpn_key_pair_${var.region}.pem; chmod 400 ~/.ssh/openvpn_key_pair_${var.region}.pem"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf openvpn.ovpn;"
  }
}

resource "aws_instance" "openvpn_ephemeral_ec2" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = var.instance_type
  tags = {
    Name = "openvpn_ephemeral"
  }
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  key_name               = aws_key_pair.openvpn_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  user_data = data.template_file.user_data.rendered

}

resource "null_resource" "obtain_ovpn_file" {
  provisioner "local-exec" {
    command = "export AWS_DEFAULT_REGION=${var.region}; until ls openvpn.ovpn; do scp -o StrictHostKeyChecking=no -i \"~/.ssh/openvpn_key_pair_${var.region}.pem\" ubuntu@${aws_instance.openvpn_ephemeral_ec2.id}:/tmp/openvpn.ovpn . ; done;"
  }

}

