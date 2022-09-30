variable "instance_type" {
  type        = string
  description = "EC2 instance type that will run openvpn service"
  default     = "t4g.micro"
}

variable "public_ip" {
  type        = string
  description = "user's personal public ip to access ec2 instance"
}

variable "region" {
  type        = string
  description = "region to deploy openvpn ec2 resource"
}
