locals {
  public_ip = get_env("TF_VAR_public_ip", "")
  region    = get_env("AWS_DEFAULT_REGION", "")
}

remote_state {
  backend = "s3"

  config = {
    region = local.region

    bucket  = "${local.region}-openvpn-ephemeral-terraform-state"
    key     = "${local.region}/terraform.tfstate"
    encrypt = true

    dynamodb_table = "openvpn-ephemeral-terraform-locks"
  }
}

inputs = {
  region    = local.region
  public_ip = local.public_ip
}
