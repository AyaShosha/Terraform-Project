output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "load_balancer_dns" {
  value = aws_elb.nginx_lb.dns_name
}
