resource "aws_s3_bucket" "openvpn_config_bucket" {
  force_destroy = true
}

resource "aws_s3_bucket_acl" "openvpn_config__acl" {
  bucket = aws_s3_bucket.openvpn_config_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "openvpn_config__policy" {
  bucket = aws_s3_bucket.openvpn_config_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OpenVPN-Download",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.openvpn_config_bucket.bucket}/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "${var.public_ip}"
                    ]
                }
                }
    }
  ]
}
POLICY
}
