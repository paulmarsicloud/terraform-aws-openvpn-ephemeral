resource "aws_iam_role" "ssm_role" {
  name = "ssm_role_${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile_${var.region}"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy" "ssm_policy" {
  name = "ssm_policy_${var.region}"
  role = aws_iam_role.ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceProperties",
          "ec2:DescribeInstances",
          "s3:GetEncryptionConfiguration",
          "ssm:StartSession"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:*:session*"
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = "${aws_key_pair.openvpn_key_pair.arn}"
      },
    ]
  })
}