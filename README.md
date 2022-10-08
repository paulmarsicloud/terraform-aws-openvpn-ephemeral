# AWS OpenVPN Ephemeral Module

## Overview

This module was created to create a quick, cheap, ephemeral OpenVPN server for a single user. The intented workflow is for the user to run `terraform apply` when they want to use a VPN in an AWS supported [region](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html) , then run `terraform destroy` when they no longer require OpenVPN usage.

The module creates an EC2 instance in the default VPC's region that the user inputs, along with a Security Group that allows the user's public IP address to access ingress port 1194 for vpn communication. The module also creates a private S3 bucket where the `openvpn.ovpn` file is uploaded to from the EC2 instance.

The `local-exec` provisioner downloads the `openvpn.ovpn` file to the user's machine after the OpenVPN service has started successfully on the EC2 instance and has been uploaded to the private S3 bucket.

## Architecture

![Visual of OpenVPN EC2 Server architecture](https://github.com/paulmarsicloud/terraform-aws-openvpn-ephemeral/raw/main/examples/architecture.png)

## Pre-requisites

To use this terraform-aws-openvpn-ephemeral module, you will need the following:

```
- AWS Account
- Default VPC in region you are using for VPN
- Terraform 1.0.0+
- Terragrunt 0.39.0+
- Mac / Linux OS
```

Creation of the default VPC can be achieved run running: `aws ec2 create-default-vpc --region <ENTER TARGET REGION HERE>`

Due to the logic of the local-exec provisioners, currently only a Mac / Linux OS are currently supported. Please submit a pull request for additional OS support.

## Usage

Please review the `examples` folder for proper module usage. Terragrunt is preferred as to easily create a S3/DynamoDB shared state backend, rather than a local terraform state.

## CICD Templates

Templates for how to use this module with GitLab. CircleCI or GitHub Actions are available here:

- [GitLab Template](https://gitlab.com/paulmarsicloud/openvpn-ephemeral-template/)
- [CircleCI Template](https://github.com/paulmarsicloud/openvpn-ephemeral-circleci-template)
- [GitHub Actions](https://github.com/paulmarsicloud/openvpn-ephemeral-github-actions-template)

## MacOS / Bash/ZSH Tips

To use the `openvpn.ovpn` file easily on Mac, download the [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-mac-os/) app and open the file to import.

Further, if you use an iPhone, you can download the [OpenVPN Connect App](https://apps.apple.com/us/app/openvpn-connect/id590379981) and then AirDrop the `openvpn.ovpn` file from your Mac to iPhone to use VPN on your iPhone!

To streamline openvpn creation per region, you can add something similar to your `~/.zshrc` or `~/.bashrc` file:

```
export TF_VAR_public_ip=$(curl ipaddr.io)

alias vpn-east-1-up='(
unset AWS_REGION;
unset AWS_DEFAULT_REGION;
export AWS_PROFILE=<YOUR AWS PROFILE NAME>;
export AWS_DEFAULT_REGION=us-east-1;
cd <FOLDER CONTAINING LOCAL TERRAFORM CODE e.g. examples/>;
terragrunt init --terragrunt-non-interactive;
terragrunt apply -auto-approve;
open openvpn.ovpn
)'

alias vpn-east-1-down='(
export AWS_PROFILE=<YOUR AWS PROFILE NAME>;
export AWS_DEFAULT_REGION=us-east-1;
cd <FOLDER CONTAINING TERRAFORM e.g. examples/>;
rm -rf openvpn.ovpn;
terragrunt destroy -auto-approve;
rm -rf .terraform && rm -rf .terraform.lock.hcl;
)'

alias vpn-west-2-up='(
unset AWS_REGION;
unset AWS_DEFAULT_REGION;
export AWS_PROFILE=<YOUR AWS PROFILE NAME>;
export AWS_DEFAULT_REGION=us-west-2;
cd <FOLDER CONTAINING LOCAL TERRAFORM CODE e.g. examples/>;
terragrunt init --terragrunt-non-interactive;
terragrunt apply -auto-approve;
open openvpn.ovpn
)'

alias vpn-west-2-down='(
export AWS_PROFILE=<YOUR AWS PROFILE NAME>;
export AWS_DEFAULT_REGION=us-west-2;
cd <FOLDER CONTAINING TERRAFORM e.g. examples/>;
rm -rf openvpn.ovpn;
terragrunt destroy -auto-approve;
rm -rf .terraform && rm -rf .terraform.lock.hcl;
)'

...
```

This way, on your local command line, you can enter `vpn-east-1-up` or `vpn-west-2-up`, wait **1-2 mins** for the OpenVPN EC2 instance to complete startup, then your connect to the profile with your local OpenVPN Connect app to access a `us-east-1` or `us-west-2` VPN. When you no longer need access to the OpenVPN service, run `vpn-east-1-down` or `vpn-west-2-down` in your command line and all the infrastructure will destroy.

It is a smarter security and monetary decision to destroy the AWS infrastructure when you are no longer using the OpenVPN service. This module is **not** intended to create a long lived EC2 service or instance, and each new `terraform apply` will start a new EC2 instance with an up to date, patched and secure AMI.

## Credits

A huge thank you to Stanislas Lange [angristan](https://github.com/angristan/) for setting up the `openvpn-install.sh` script [here](https://github.com/angristan/openvpn-install) - this is where the _majority_ of the openvpn logic comes from, so without this script, the standup time would be a lot slower!
