output "certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.main-cdn.arn
}