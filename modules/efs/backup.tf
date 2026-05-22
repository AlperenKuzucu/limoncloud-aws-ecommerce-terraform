resource "aws_backup_vault" "efs_vault" {
  name = "${var.efs_name}-vault"
}

resource "aws_backup_plan" "efs_backup_plan" {
  name = "${var.efs_name}-backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.efs_vault.name
    schedule          = "cron(0 5 * * ? *)" # Daily at 05:00 AM

    lifecycle {
      delete_after = 30 # Keep backups for 30 days
    }
  }
}

resource "aws_iam_role" "backup_role" {
  name = "${var.efs_name}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_selection" "efs_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${var.efs_name}-efs-selection"
  plan_id      = aws_backup_plan.efs_backup_plan.id

  resources = [
    aws_efs_file_system.efs_file_system.arn
  ]
}
