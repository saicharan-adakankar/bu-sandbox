## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.15 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.alb_waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_ip_set.blocklist_alb_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.blocklist_alb_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AWSRateBasedRuleDomesticDOS_limit"></a> [AWSRateBasedRuleDomesticDOS\_limit](#input\_AWSRateBasedRuleDomesticDOS\_limit) | Rate limit for domestic dos protection | `number` | `2000` | no |
| <a name="input_AWSRateBasedRuleGlobalDOS_limit"></a> [AWSRateBasedRuleGlobalDOS\_limit](#input\_AWSRateBasedRuleGlobalDOS\_limit) | Rate limit for global dos protection | `number` | `500` | no |
| <a name="input_alb_ipsets_v4"></a> [alb\_ipsets\_v4](#input\_alb\_ipsets\_v4) | ipv4 ips to to be blocklisted | `list(string)` | <pre>[<br>  "127.0.0.1/32"<br>]</pre> | no |
| <a name="input_alb_ipsets_v6"></a> [alb\_ipsets\_v6](#input\_alb\_ipsets\_v6) | ipv6 ips to to be blocklisted | `list(string)` | <pre>[<br>  "2001:0db8:0000:0000:0000:0000:0000:0001/128"<br>]</pre> | no |
| <a name="input_blocked_countries"></a> [blocked\_countries](#input\_blocked\_countries) | Countries to block | `list(string)` | <pre>[<br>  "CU",<br>  "IR",<br>  "KP",<br>  "SY",<br>  "MM",<br>  "SS"<br>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_na_geo_match_set"></a> [na\_geo\_match\_set](#input\_na\_geo\_match\_set) | Countries with higher allowed rate of requests | `list(string)` | <pre>[<br>  "US",<br>  "CA"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | WAF Web Acl ARN |
