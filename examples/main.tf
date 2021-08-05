variable "region" {}
variable "public_ip" {}

module "openvpn-ephemeral" {
  source  = "paulmarsicloud/openvpn-ephemeral/aws"
  version = "0.3.0"
  region = var.region
  public_ip = var.public_ip
}