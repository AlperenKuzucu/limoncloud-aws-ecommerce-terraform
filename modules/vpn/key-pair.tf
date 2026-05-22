resource "tls_private_key" "pritunl" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "pritunl" {
  key_name   = "Pritunl-${var.project}"
  public_key = tls_private_key.pritunl.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pritunl.private_key_pem}' > ../modules/vpn/Pritunl-${var.project}.pem"
  }
}