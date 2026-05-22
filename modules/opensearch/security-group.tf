resource "aws_security_group" "opensearch" {
  name        = "${var.domain_name}-OpenSearch-SG"
  description = "${var.domain_name}-OpenSearch-SG"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.domain_name}-OpenSearch-SG"

  }
}