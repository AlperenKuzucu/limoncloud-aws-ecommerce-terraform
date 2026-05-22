resource "aws_security_group" "elasticache-sg" {
  name        = "${var.cluster_id}-sg"
  description = "${var.cluster_id}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "Elasticache Security Group"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.cluster_id}-sg"
  }
}