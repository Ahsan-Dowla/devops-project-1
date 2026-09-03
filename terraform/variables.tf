variable "aws_region" {
  description = "AWS region containing the existing production infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "instance_id" {
  description = "Existing EC2 instance ID to import and manage."
  type        = string
}

variable "ami_id" {
  description = "AMI ID currently used by the existing EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "Instance type currently used by the existing EC2 instance."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID currently used by the existing EC2 instance."
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name currently attached to the instance."
  type        = string
}

variable "security_group_id" {
  description = "Existing security group ID attached to the instance."
  type        = string
}

variable "security_group_name" {
  description = "Name of the existing EC2 security group."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID containing the existing security group."
  type        = string
}
