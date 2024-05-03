data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/arm64/hvm/ebs-gp2/ami-id"
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

resource "aws_instance" "openvpn_ephemeral_ec2" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = var.instance_type
  tags = {
    Name = "openvpn_ephemeral"
  }
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  user_data = templatefile("${path.module}/user_data.tpl", {
    s3_bucket = "${aws_s3_bucket.openvpn_config_bucket.bucket}"
  })
}

resource "null_resource" "obtain_ovpn_file" {
  depends_on = [aws_instance.openvpn_ephemeral_ec2]
  provisioner "local-exec" {
    command = "export AWS_DEFAULT_REGION=${var.region}; until ls openvpn.ovpn; do aws s3 cp s3://${aws_s3_bucket.openvpn_config_bucket.bucket}/openvpn.ovpn . ; sleep 5; done;"
  }

}
