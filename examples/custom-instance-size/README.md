# openvpn-ephemeral

=====================

The example is setup to show how providing your public IP address and and the region you want to deploy the OpenVPN EC2 server to via `TF_VAR_public_ip` and `TF_VAR_region` environment variables, the terraform module will standup the infrastructure required in your AWS account and desired region.

```
export TF_VAR_public_ip=123.456.789.101
export TF_VAR_region=us-east-1
terragrunt init
terragrunt apply
```
