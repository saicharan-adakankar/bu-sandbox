# Look up your EXISTING Web ACL by name (REGIONAL scope)
data "aws_wafv2_web_acl" "existing" {
  name  = var.waf_web_acl_name
  scope = "REGIONAL"
}

# Associate it to the newly created ALB
resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = aws_lb.app.arn
  web_acl_arn  = data.aws_wafv2_web_acl.existing.arn
}
