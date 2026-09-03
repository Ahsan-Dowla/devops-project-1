output "ec2_instance_id" {
  description = "Existing production EC2 instance ID."
  value       = aws_instance.production.id
}

output "ec2_public_ip" {
  description = "Public IPv4 address of the production EC2 instance."
  value       = aws_instance.production.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the production EC2 instance."
  value       = aws_instance.production.public_dns
}

output "ec2_instance_type" {
  description = "Production EC2 instance type."
  value       = aws_instance.production.instance_type
}

output "security_group_id" {
  description = "Existing production security group ID."
  value       = aws_security_group.production.id
}
