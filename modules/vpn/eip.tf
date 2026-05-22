resource "aws_eip" "pritunl" {
  domain = "vpc"

  tags = {
    Name = "Pritunl-eip"

  }
}

resource "aws_eip_association" "pritunl" {
  allocation_id = aws_eip.pritunl.allocation_id
  instance_id   = aws_instance.pritunl.id

  depends_on = [aws_eip.pritunl]
}