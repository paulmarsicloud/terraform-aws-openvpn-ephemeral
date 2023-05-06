resource "aws_s3_bucket" "openvpn_config_bucket" {
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "openvpn_config_bucket" {
  bucket = aws_s3_bucket.openvpn_config_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "openvpn_config_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.openvpn_config_bucket]
  bucket     = aws_s3_bucket.openvpn_config_bucket.id
  acl        = "private"
}
