variable "region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "bastion_ami" {}
variable "bastion_instance_type" {}
variable "nginx_ami" {}
variable "nginx_instance_type" {}
