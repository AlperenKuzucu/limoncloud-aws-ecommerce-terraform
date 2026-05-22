resource "aws_opensearch_domain" "main" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = true
  }

  vpc_options {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.opensearch.id]
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = random_password.master_opensearch.result
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 30
  }

  depends_on = [
    random_password.master_opensearch
  ]


}


resource "aws_opensearch_domain_policy" "main" {
  domain_name = aws_opensearch_domain.main.domain_name

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "${aws_opensearch_domain.main.arn}/*"
    }
  ]
}
POLICIES
}