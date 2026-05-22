resource "aws_security_group" "pritunl-sg" {
  description = "Pritunl-sg"
  name        = "Pritunl-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "Pritunl web console HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Pritunl OpenVPN UDP"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "LimonOfis-SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.154.22.34/32"]
  }

  ingress {
    description = "Alp-SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.252.138.114/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Pritunl-sg"
  }
}