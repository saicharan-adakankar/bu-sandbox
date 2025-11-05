variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

# Name of the existing WAF Web ACL you already created elsewhere
variable "waf_web_acl_name" {
  type        = string
  default     = "charan-waf-local-alb-web-acl"
  description = "Existing WAFv2 Web ACL name (REGIONAL)"
}

# Project/prefix only used for naming the ALB/VPC bits
variable "project_name" {
  type        = string
  default     = "charan-alb"
  description = "Naming prefix for ALB/VPC resources"
}

# VPC CIDRs
variable "vpc_cidr" {
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.30.0.0/24", "10.30.1.0/24"]
}
