resource "aws_s3_bucket" "bucket_01" {
  bucket = "${var.project}-media"

  tags = {
    Name = "${var.project}-media"
  }
}


resource "aws_s3_bucket_policy" "bucket_01" {
  bucket = aws_s3_bucket.bucket_01.bucket

  policy = jsonencode(
    {
      Id = "PolicyForCloudFrontPrivateContent"
      Statement = [
        {
          Action = "s3:GetObject"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai_01.id}"
          }
          Resource = "arn:aws:s3:::${aws_s3_bucket.bucket_01.bucket}/*"
          Sid      = "1"
        },
      ]
      Version = "2008-10-17"
    }
  )
}

##########################################################################################
##########################################################################################


locals {
  s3_origin_id  = "S3-${aws_s3_bucket.bucket_01.bucket}"
  alb_origin_id = "ALB-${var.project}"
}

resource "aws_cloudfront_origin_access_identity" "oai_01" {
  comment = "${var.project}-media"
}

resource "aws_cloudfront_distribution" "cdn_01" {
  # ALB Origin (Main Site)
  origin {
    domain_name = var.load_balancer_dns_name
    origin_id   = local.alb_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # S3 Origin (Media)
  origin {
    domain_name = aws_s3_bucket.bucket_01.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai_01.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront for ${var.aliases}"
  default_root_object = ""

  aliases = [var.aliases]

  # Default Behavior (Points to ALB)
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.alb_origin_id

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin", "Authorization"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0 # Dynamic content should not be cached by default
    max_ttl                = 0
  }

  # Ordered Behavior (Points to S3 for Media)
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  wait_for_deployment = false
}
