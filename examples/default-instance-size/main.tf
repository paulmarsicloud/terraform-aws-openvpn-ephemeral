variable "region" {}
variable "public_ip" {}

terraform {
  backend "s3" {}
}

module "openvpn-ephemeral" {
  source    = "paulmarsicloud/openvpn-ephemeral/aws"
  version   = "1.0.1"
  region    = var.region
  public_ip = var.public_ip
}
