variable "instance_type" {
  type        = string
  description = "EC2 instance type that will run openvpn service"
  default     = "t4g.micro"
}

variable "output_suppression" {
  type        = string
  description = "this is an unused variable, referenced purely to suppress the tls key echo from the provisioner command line outputs"
  sensitive   = true
  default     = "secret"
}

variable "public_ip" {
  type        = string
  description = "user's personal public ip to access ec2 instance"
  default     = ""
}

variable "region" {
  type        = string
  description = "region to deploy openvpn ec2 resource"
  default     = ""
}
