resource "aws_efs_file_system" "efs_file_system" {
  creation_token = "${var.efs_name}-efs"

  tags = {
    Name = "${var.efs_name}-efs"
  }
}

resource "aws_efs_mount_target" "efs-mount" {
  count           = length(var.data_subnets)
  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = element(var.data_subnets, count.index)
  security_groups = [aws_security_group.efs_allow_access.id]
}