#####
# Backup Vault
#####
resource "aws_backup_vault" "aurora_vault" {
  name        = var.vault_name
  #kms key arn below for protecting backups (see variables.tf)
  kms_key_arn = var.kms_key_arn
}

#####
# Backup Plan
#####
resource "aws_backup_plan" "backup" {
  name = "aurora_backup_vault"

  rule {
    rule_name         = "backup_rule_main"
    target_vault_name = var.vault_name
    # cron backup every 24 hours starting at 00:00
    schedule          = "cron(0 0 0/24 ? * * *)"

    lifecycle {
      delete_after = 1
    }
  }
}

####
# Resources to Backup
####
resource "aws_backup_selection" "example" {
  iam_role_arn = var.iam_role_name
  name         = "aurora_backup_selection"
  plan_id      = aws_backup_plan.backup

  resources = [
    var.resource_backup
  ]
}

#####
# IAM Role
#####
resource "aws_iam_role" "backup_role" {
  name               = "aurora_backup_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = var.iam_role_name
}


