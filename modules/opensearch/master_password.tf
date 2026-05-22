resource "random_password" "master_opensearch" {
  length           = 16
  upper            = true
  numeric          = true
  special          = true
  override_special = "_!%^"
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
}


resource "aws_secretsmanager_secret" "password_opensearch" {
  name                    = "${var.domain_name}-OpenSearch-Master-Password"
  recovery_window_in_days = 7
}
resource "aws_secretsmanager_secret_version" "password_opensearch" {
  secret_id = aws_secretsmanager_secret.password_opensearch.id
  secret_string = jsonencode({
    Master_Username = "${var.master_user_name}"
    Master_Password = "${random_password.master_opensearch.result}"
    }

  )
}
