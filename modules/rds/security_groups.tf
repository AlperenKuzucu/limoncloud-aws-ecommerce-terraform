resource "aws_security_group" "rds_db" {
  name        = "${var.project}-RDS-SG"
  description = "${var.project}-RDS-SG"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.port
    to_port     = var.port
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-RDS-SG"

  }
}