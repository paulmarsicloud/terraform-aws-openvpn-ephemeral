variable "region" {}
variable "public_ip" {}
variable "instance_type" {}

terraform {
  backend "s3" {}
}

module "openvpn-ephemeral" {
  source        = "paulmarsicloud/openvpn-ephemeral/aws"
  version       = "1.1.0"
  region        = var.region
  public_ip     = var.public_ip
  instance_type = var.instance_type
}
