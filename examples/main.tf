module "openvpn-ephemeral" {
  source  = "paulmarsicloud/openvpn-ephemeral/aws"
  version = "0.1.0"
  public_ip = "123.456.789.101"
  region = "us-east-1"
}