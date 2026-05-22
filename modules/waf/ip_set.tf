resource "aws_wafv2_ip_set" "allowed" {
  addresses          = []
  description        = "allowed-IPs"
  name               = "allowed-IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
}


resource "aws_wafv2_ip_set" "blocked" {
  addresses          = []
  description        = "blocked-IPs"
  name               = "blocked-IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
}


resource "aws_wafv2_ip_set" "blocked_ipv6" {
  addresses          = []
  description        = "blocked-IPv6"
  name               = "blocked-IPv6"
  scope              = "REGIONAL"
  ip_address_version = "IPV6"
}