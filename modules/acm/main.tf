resource "aws_acm_certificate" "main" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]

}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-lab"
  alias   = "us-east-1"
}

resource "aws_acm_certificate" "main-cdn" {
  provider                  = aws.us-east-1
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
}

resource "aws_acm_certificate_validation" "main-cdn" {
  provider        = aws.us-east-1
  certificate_arn = aws_acm_certificate.main-cdn.arn
}
