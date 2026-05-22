resource "aws_rds_cluster" "rds_db" {
  deletion_protection             = false
  engine                          = var.engine
  engine_mode                     = var.engine_mode
  engine_version                  = var.engine_version
  cluster_identifier              = lower(var.cluster_identifier)
  database_name                   = replace(var.database_name, "-", "")
  master_username                 = var.master_username
  master_password                 = random_password.rds_master.result
  storage_encrypted               = true
  backup_retention_period         = 7
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  allow_major_version_upgrade     = false
  db_subnet_group_name            = aws_db_subnet_group.rds_db.name
  vpc_security_group_ids          = [aws_security_group.rds_db.id]
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  skip_final_snapshot             = true


  depends_on = [random_password.rds_master]
}


resource "aws_rds_cluster_instance" "rds_instance" {
  count                = var.instance_count
  identifier           = "${lower(var.cluster_identifier)}-${count.index}"
  cluster_identifier   = aws_rds_cluster.rds_db.id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.rds_db.engine
  engine_version       = aws_rds_cluster.rds_db.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.rds_db.name
}