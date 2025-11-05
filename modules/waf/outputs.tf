output "arn" {
  value       = aws_wafv2_web_acl.web_acl.arn
  description = "WAF Web Acl ARN"
}
