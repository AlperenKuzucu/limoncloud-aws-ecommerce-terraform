resource "aws_security_group" "efs_allow_access" {
  name        = "${var.efs_name}-efs-sg"
  description = "${var.efs_name}-efs-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
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
    Name = "${var.efs_name}-efs-sg"
  }
}