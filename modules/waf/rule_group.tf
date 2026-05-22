resource "aws_wafv2_rule_group" "allowed" {
  description = "allowed-IPs"
  name        = "allowed-IPs"
  scope       = "REGIONAL"
  capacity    = 1

  rule {
    name     = "allowed-IPs"
    priority = 0

    action {
      allow {
      }
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allowed-IPs"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "allowed-IPs"
    sampled_requests_enabled   = true
  }
}


resource "aws_wafv2_rule_group" "country" {
  description = "country-restriction"
  name        = "country-restriction"
  scope       = "REGIONAL"
  capacity    = 1

  rule {
    name     = "country-restriction"
    priority = 0

    action {
      block {
      }
    }

    statement {
      geo_match_statement {
        country_codes = [
          "CN",
          "RU",
          "IN",
        ]
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
    metric_name                = "country-restriction"
    sampled_requests_enabled   = true
  }
}