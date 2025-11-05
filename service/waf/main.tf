# naming helper ONLY (no cluster/ALB required)
locals {
  cluster_name = "charan-waf-local"
}

# 1) create the web acl via your existing module
module "alb_waf" {
  source = "../../modules/waf"

  cluster_name                      = local.cluster_name
  AWSRateBasedRuleDomesticDOS_limit = 40000
  AWSRateBasedRuleGlobalDOS_limit   = 500
}

# 2) override TWO CRS subrules on THAT SAME acl (no new acl created)
resource "null_resource" "override_crs_rules" {
  depends_on = [module.alb_waf]

  provisioner "local-exec" {
    command = <<EOT
      echo "Fetching WebACL '${local.cluster_name}-alb-web-acl'…"

      ACL_ID=$(aws wafv2 list-web-acls \
        --scope REGIONAL \
        --query "WebACLs[?Name=='${local.cluster_name}-alb-web-acl'].Id" \
        --output text)

      LOCK_TOKEN=$(aws wafv2 get-web-acl \
        --name ${local.cluster_name}-alb-web-acl \
        --scope REGIONAL \
        --query "LockToken" \
        --output text)

      cat > /tmp/rule_override.json <<'JSON'
      [
        {
          "Name": "AWSManagedRulesCommonRuleSet",
          "Priority": 10,
          "OverrideAction": { "Count": {} },
          "Statement": {
            "ManagedRuleGroupStatement": {
              "VendorName": "AWS",
              "Name": "AWSManagedRulesCommonRuleSet",
              "RuleActionOverrides": [
                { "Name": "NoUserAgent_HEADER",       "ActionToUse": { "Block": {} } },
                { "Name": "UserAgent_BadBots_HEADER", "ActionToUse": { "Block": {} } }
              ]
            }
          },
          "VisibilityConfig": {
            "CloudWatchMetricsEnabled": true,
            "SampledRequestsEnabled": true,
            "MetricName": "AWSManagedRulesCommonRuleSetMetric"
          }
        }
      ]
      JSON

      echo "Applying rule overrides to WebACL ID: $ACL_ID …"
      aws wafv2 update-web-acl \
        --region us-east-1 \
        --scope REGIONAL \
        --id $ACL_ID \
        --name ${local.cluster_name}-alb-web-acl \
        --lock-token $LOCK_TOKEN \
        --default-action Allow={} \
        --rules file:///tmp/rule_override.json

      echo "Done: overrides applied to ${local.cluster_name}-alb-web-acl"
    EOT
  }
}
