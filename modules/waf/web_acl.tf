resource "aws_wafv2_web_acl" "main" {
  description = var.description
  name        = var.web_acl_name
  scope       = "REGIONAL"

  default_action {
    allow {
    }
  }

  rule {
    name     = "blocked-IPs"
    priority = 2

    action {
      block {
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blocked-IPs"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "blocked-IPv6"
    priority = 3

    action {
      block {
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ipv6.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blocked-IPv6"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "rate-limit"
    priority = 4

    action {
      count {
      }
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "FORWARDED_IP"
        limit              = 1000

        forwarded_ip_config {
          fallback_behavior = "MATCH"
          header_name       = "CF-Connecting-IP"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 11

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "AdminProtection_URIPATH"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 6

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"

        rule_action_override {
          name = "AWSManagedIPDDoSList"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "AWSManagedIPReputationList"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "AWSManagedReconnaissanceList"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 7

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        rule_action_override {
          name = "AnonymousIPList"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "HostingProviderIPList"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 9

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "COMMON"
          }
        }

        rule_action_override {
          name = "CategoryAdvertising"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryArchiver"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryContentFetcher"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryEmailClient"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryHttpLibrary"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryLinkChecker"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryMiscellaneous"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryMonitoring"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategoryScrapingFramework"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySearchEngine"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySecurity"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySeo"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CategorySocialMedia"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalAutomatedBrowser"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalKnownBotDataCenter"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SignalNonBrowserUserAgent"

          action_to_use {
            count {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "CrossSiteScripting_BODY"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_COOKIE"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_BODY"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_COOKIE"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "MetaDataSSRF_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "GenericLFI_BODY"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "GenericLFI_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "GenericLFI_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "GenericRFI_BODY"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "GenericRFI_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "GenericRFI_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "NoUserAgent_HEADER"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "RestrictedExtensions_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "RestrictedExtensions_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "SizeRestrictions_BODY"

          action_to_use {
            count {
            }
          }
        }
        rule_action_override {
          name = "SizeRestrictions_Cookie_HEADER"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "SizeRestrictions_QUERYSTRING"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "SizeRestrictions_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "UserAgent_BadBots_HEADER"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 8

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "ExploitablePaths_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "Host_localhost_HEADER"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "JavaDeserializationRCE_BODY"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "JavaDeserializationRCE_HEADER"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "JavaDeserializationRCE_QUERYSTRING"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "JavaDeserializationRCE_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "Log4JRCE_BODY"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "Log4JRCE_HEADER"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "Log4JRCE_QUERYSTRING"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "Log4JRCE_URIPATH"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "PROPFIND_METHOD"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesPHPRuleSet"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesPHPRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesWindowsRuleSet"
    priority = 12

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWindowsRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "WindowsShellCommands_COOKIE"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "WindowsShellCommands_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "WindowsShellCommands_BODY"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "PowerShellCommands_COOKIE"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "PowerShellCommands_QUERYARGUMENTS"

          action_to_use {
            block {
            }
          }
        }
        rule_action_override {
          name = "PowerShellCommands_BODY"

          action_to_use {
            block {
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesWindowsRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "allowed-IPs"
    priority = 0

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.allowed.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allowed-IPs"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "country-restriction"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.country.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "country-restriction"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "paynet-prod-web-acl"
    sampled_requests_enabled   = true
  }
}