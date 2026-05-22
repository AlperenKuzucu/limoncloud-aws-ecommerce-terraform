resource "aws_security_group" "mq_sg" {
  name        = "${var.project}-mq-sg"
  description = "${var.project}-mq-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "RabbitMQ AMQPS"
    from_port   = var.port 
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "RabbitMQ web console HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "${var.project}-mq-sg"
  }
}