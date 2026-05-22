resource "aws_subnet" "public_subnets" {
  count             = length(var.public-subnet-map)
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.public-subnet-map[count.index], "cidr")
  availability_zone = lookup(var.public-subnet-map[count.index], "az")

  tags = {
    Name = "${lookup(var.public-subnet-map[count.index], "name")}"


  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private-subnet-map)
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.private-subnet-map[count.index], "cidr")
  availability_zone = lookup(var.private-subnet-map[count.index], "az")

  tags = {
    Name = "${lookup(var.private-subnet-map[count.index], "name")}"


  }
}

resource "aws_subnet" "data_subnets" {
  count             = length(var.data-subnet-map)
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.data-subnet-map[count.index], "cidr")
  availability_zone = lookup(var.data-subnet-map[count.index], "az")

  tags = {
    Name = "${lookup(var.data-subnet-map[count.index], "name")}"

  }
}