resource "aws_wafv2_ip_set" "blocklist_alb_ipv4" {
  name               = "${var.cluster_name}-alb-ipv4"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.alb_ipsets_v4

  tags = {
    Name = "${var.cluster_name}-alb-ipv4"
  }
}

resource "aws_wafv2_ip_set" "blocklist_alb_ipv6" {
  name               = "${var.cluster_name}-alb-ipv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
  addresses          = var.alb_ipsets_v6

  tags = {
    Name = "${var.cluster_name}-alb-ipv6"
  }
}

resource "aws_wafv2_web_acl" "web_acl" {
  name  = "${var.cluster_name}-alb-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSBlockCountries"
    priority = 0

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = var.blocked_countries
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSBlockCountries"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWSRateBasedRuleDomesticDOS"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.AWSRateBasedRuleDomesticDOS_limit
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = var.na_geo_match_set
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleDomesticDOS"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSRateBasedRuleGlobalDOS"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.AWSRateBasedRuleGlobalDOS_limit
        aggregate_key_type = "IP"

        scope_down_statement {
          not_statement {
            statement {
              geo_match_statement {
                country_codes = var.na_geo_match_set
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleGlobalDOS"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSIPBlackList"
    priority = 3

    action {
      block {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.blocklist_alb_ipv4.arn
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.blocklist_alb_ipv6.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSIPBlackList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BlockFeroxBuster"
    priority = 7

    action {
      block {}
    }

    statement {
      byte_match_statement {
        positional_constraint = "STARTS_WITH"
        search_string         = "feroxbuster"
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockFeroxBuster"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 30

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 40

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 50

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 60

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesUnixRuleSet"
    priority = 70

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesUnixRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = "${var.cluster_name}-alb-web-acl"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.cluster_name
    sampled_requests_enabled   = true
  }
}


resource "aws_cloudwatch_log_group" "alb_waf_logs" {
  name = "aws-waf-logs-${var.cluster_name}"
}

resource "aws_wafv2_web_acl_logging_configuration" "config" {
  log_destination_configs = [aws_cloudwatch_log_group.alb_waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn
}
