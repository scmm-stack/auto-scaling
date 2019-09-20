locals {
  http_port     = 80
  ssh_port      = 22
  any_port      = 0
  ping_port     = 8
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  http_protocol = "HTTP"
  ping_protocol = "icmp"
  all_ips       = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = "ID of the custom VPC."
  type        = string
}
variable "as-subnets_ids" {
  description = "IDs of the subnets to use with ASG."
  type        = list(string)
}
variable "allowed_cidr_blocks" {
  description = "The IP range alowed to connect from."
  //type = string
}
variable "alb_security_group_id" {
  description = "ID of the Application Load Balancer."
  //type = string
}
variable "alb-target-group_arn" {
  description = "ARN of the Application Load Balancer target group."
  type        = string
}
variable "autoscaling_group_min_size" {
  description = "The minimum size of the auto scaling group."
  type        = number
}
variable "autoscaling_group_max_size" {
  description = "The maximum size of the auto scaling group."
  type        = number
}

# EC2 settings:

variable "auto_scaling_instance_type" {
  description = "The type of the EC2 instance that will launched by the ASG."
  type        = string
  default     = "t2.micro"
}
variable "public_key" {
  description = "Name of the existing SSH key pair to use with EC2 instances."
  type        = string
}
variable "detailed_monitoring" {
  description = "Enable / disable detailed monitoring. Disable to stay under the free tier limits."
  default     = false
}
