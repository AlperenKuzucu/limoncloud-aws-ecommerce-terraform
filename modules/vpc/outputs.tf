output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "private_subnet_cidr" {
  value = aws_subnet.private_subnets.*.cidr_block
}

output "data_subnets" {
  value = aws_subnet.data_subnets.*.id
}

output "data_subnet_cidr" {
  value = aws_subnet.data_subnets.*.cidr_block
}