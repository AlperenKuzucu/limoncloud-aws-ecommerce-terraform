resource "aws_db_subnet_group" "rds_db" {
  name       = lower("${var.project}_db_subnetgroup")
  subnet_ids = var.data_subnets


}