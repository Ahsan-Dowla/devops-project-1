import {
  to = aws_instance.production
  id = var.instance_id
}

import {
  to = aws_security_group.production
  id = var.security_group_id
}

resource "aws_instance" "production" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  lifecycle {
    prevent_destroy = true

    # These values describe an already-running server. Do not replace or
    # reconfigure production because a local variable is incomplete.
    ignore_changes = [
      ami,
      instance_type,
      subnet_id,
      key_name,
      vpc_security_group_ids,
      associate_public_ip_address,
      root_block_device,
      ebs_block_device,
      user_data,
      tags,
    ]
  }
}

resource "aws_security_group" "production" {
  name        = var.security_group_name
  description = "Existing security group for the production EC2 instance"
  vpc_id      = var.vpc_id

  # Keep the documented application access rules visible in IaC. Existing
  # rules are preserved after import; PostgreSQL is intentionally absent.
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    prevent_destroy = true

    # Rule ownership is intentionally conservative for an existing SG.
    # Review actual AWS rules before removing this guard.
    ignore_changes = [name, description, vpc_id, ingress, egress, tags]
  }
}
