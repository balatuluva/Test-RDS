resource "random_password" "db_pass" {
  length = 15
  special = true
  override_special = "!%"
}

resource "aws_secretsmanager_secret" "db_secret_passkey" {
  name = "db_secret_passkey"
}

resource "aws_secretsmanager_secret_version" "db_secret_ver" {
  secret_string = random_password.db_pass.result
  secret_id = aws_secretsmanager_secret.db_secret_passkey.id
}