# Create an autoscaling group

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = aws_launch_configuration.launch_configuration-http_srv.id
  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  target_group_arns    = [var.alb-target-group_arn]

  #vpc_zone_identifier = subnets
  vpc_zone_identifier = var.as-subnets_ids
  health_check_type   = "ELB"
}

# Create a security group for the EC2 instances starting in the ASG

resource "aws_security_group" "security_group-ec2-http-ssh-icmp" {
  name        = "security-group-default"
  description = "Terra security group"
  vpc_id      = var.vpc_id

  # Allow outbound internet access.
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = local.tcp_protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = local.ping_port
    to_port     = local.any_port
    protocol    = local.ping_port
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port       = local.http_port
    to_port         = local.http_port
    protocol        = local.tcp_protocol
    security_groups = var.alb_security_group_id
  }
  tags = {
    name = "terra-security-group"
  }
}

# Create a launch configuration
resource "aws_launch_configuration" "launch_configuration-http_srv" {
  name_prefix = "launch_configuration-ec2_web"
  image_id    = data.aws_ami.ubuntu-18-04-srv.id

  # The default instance type is set to t2.micro
  instance_type   = var.auto_scaling_instance_type
  key_name        = var.public_key
  security_groups = [aws_security_group.security_group-ec2-http-ssh-icmp.id]

  # Create the "health_check" file. Each EC2 instance will run a http server. See setup.sh for more details.
  user_data                   = file("${path.module}/setup.sh")
  associate_public_ip_address = true

  #Enables/disables detailed monitoring. This is enabled by default (by AWS).
  enable_monitoring = var.detailed_monitoring

  # The new replacement EC2 instance will be created first, and then the prior one will be destroyed.
  lifecycle {
    create_before_destroy = true
  }
}
