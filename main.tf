terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1" // Change as needed
}

module "vpc" {
  source = "./modules/vpc"

  region                = var.region
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  nginx_ami             = var.nginx_ami
  nginx_instance_type   = var.nginx_instance_type
}
