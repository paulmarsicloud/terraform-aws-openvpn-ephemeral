output "instance_id" {
  description = "EC2 instance id of openvpn server"
  value = aws_instance.openvpn_ephemeral_ec2.id
}