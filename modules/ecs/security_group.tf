resource "aws_security_group" "ecs-sg" {
  name   = "${var.project}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3978
    to_port     = 3978
    protocol    = "tcp"
    self        = false
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    self        = false
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = false
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project}-ecs-sg"
  }
}
