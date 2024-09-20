provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
}

resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.main.id
  // Define your security group rules here
}

resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.public[0].id
  security_groups = [aws_security_group.bastion.name]
}

resource "aws_instance" "nginx_private_1" {
  ami           = var.nginx_ami
  instance_type = var.nginx_instance_type
  subnet_id     = aws_subnet.private[0].id
  // Security group to allow access from Load Balancer
}

resource "aws_instance" "nginx_private_2" {
  ami           = var.nginx_ami
  instance_type = var.nginx_instance_type
  subnet_id     = aws_subnet.private[1].id
  // Security group to allow access from Load Balancer
}

resource "aws_elb" "nginx_lb" {
  name               = "nginx-lb"
  availability_zones = var.availability_zones

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }

  instances = [
    aws_instance.nginx_private_1.id,
    aws_instance.nginx_private_2.id,
  ]
}
