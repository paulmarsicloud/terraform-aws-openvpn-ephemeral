output "instance_id" {
  description = "EC2 instance id of openvpn server"
  value       = aws_instance.openvpn_ephemeral_ec2.id
}

output "bucket_name" {
  description = "bucket name created by Terraform"
  value       = aws_s3_bucket.openvpn_config_bucket.bucket
}
