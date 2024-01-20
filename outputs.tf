## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2-bastion.public_ip
}

## ec2_private_ip
output "app1_ec2_private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = [for ec2private in module.ec2-private : ec2private.private_ip]
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.dns_name
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rdsdb.db_instance_address
}
