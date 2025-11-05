variable "AWSRateBasedRuleDomesticDOS_limit" {
  type        = number
  default     = 2000
  description = "Rate limit for domestic dos protection"
}

variable "AWSRateBasedRuleGlobalDOS_limit" {
  type        = number
  default     = 500
  description = "Rate limit for global dos protection"
}

variable "alb_ipsets_v4" {
  type        = list(string)
  default     = ["127.0.0.1/32"]
  description = "ipv4 ips to to be blocklisted"
}

variable "alb_ipsets_v6" {
  type        = list(string)
  default     = ["2001:0db8:0000:0000:0000:0000:0000:0001/128"]
  description = "ipv6 ips to to be blocklisted"
}

variable "blocked_countries" {
  type        = list(string)
  default     = ["CU", "IR", "KP", "SY", "MM", "SS"] # Cuba, Iran, North Korea, Syria, Burma/Myanmar, South Sudan
  description = "Countries to block"
}

variable "cluster_name" {
  type = string
}

variable "na_geo_match_set" {
  type        = list(string)
  default     = ["US", "CA"]
  description = "Countries with higher allowed rate of requests"
}
