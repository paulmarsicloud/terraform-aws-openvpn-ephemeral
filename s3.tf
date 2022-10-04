resource "aws_s3_bucket" "openvpn_config_bucket" {
  force_destroy = true
}

resource "aws_s3_bucket_acl" "openvpn_config__acl" {
  bucket = aws_s3_bucket.openvpn_config_bucket.id
  acl    = "private"
}

