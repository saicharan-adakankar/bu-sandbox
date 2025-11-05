output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.app.dns_name
}

output "waf_acl_arn" {
  description = "ARN of the existing WAF ACL that is attached"
  value       = data.aws_wafv2_web_acl.existing.arn
}
