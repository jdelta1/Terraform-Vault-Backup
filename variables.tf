variable "kms_key_arn" {
  type        = string
  description = "KMS key used to protect backups"
  default     = null
  sensitive = true
}

variable "vault_name" {
  description = "Name of the backup vault to create. Will use AWS default if not declared."
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "Name of Backup Plan IAM Role"
  type        = string
  default     = null
}

variable "resource_backup" {
  description = "Resource ARN(s) to include in backup"
  type        = string
  default     = null
}