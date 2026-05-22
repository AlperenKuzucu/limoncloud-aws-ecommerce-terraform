resource "aws_eip" "eip" {
  count    = length(var.private-subnet-map)
  domain   = "vpc"

  tags = {
    Name = "${var.project}-NATGW-${lookup(var.private-subnet-map[count.index], "az")}-eip"
  }
}


resource "aws_nat_gateway" "nat" {
  count         = length(var.private-subnet-map)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.project}-NATGW-${lookup(var.private-subnet-map[count.index], "az")}"
  }
}