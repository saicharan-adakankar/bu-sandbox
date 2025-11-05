module "alb_waf" {
  source = "../modules/waf"

  cluster_name                      = "charan-waf-local"
  AWSRateBasedRuleDomesticDOS_limit = 40000
  AWSRateBasedRuleGlobalDOS_limit   = 500
}

# Override the managed rule group behavior directly
resource "aws_wafv2_web_acl" "charan_waf_override" {
  name  = "charan-waf-local"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # Here's the key — you’re overriding two specific rules:
        rule_action_override {
          name = "NoUserAgent_HEADER"
          action_to_use {
            block {}
          }
        }

        rule_action_override {
          name = "BadBots_HEADER"
          action_to_use {
            block {}
          }
        }
      }
    }

    override_action {
      count {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "charan-waf-local"
    sampled_requests_enabled   = true
  }
}
