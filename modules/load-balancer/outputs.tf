output "load_balancer_arn" {
  value = aws_lb.main.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}